import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/desktop_client_creds.dart' as hidden_creds;
import 'package:keeper_of_projects/backend/google_api/desktop_token_storage.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:window_to_front/window_to_front.dart';

List<String> scopes = [drive.DriveApi.driveFileScope, 'https://www.googleapis.com/auth/userinfo.profile', 'https://www.googleapis.com/auth/userinfo.email'];

const String authorizationEndpoint = "https://accounts.google.com/o/oauth2/v2/auth";
const String tokenEndpoint = "https://oauth2.googleapis.com/token";
const String clientId = hidden_creds.clientID;
const String clientSecret = hidden_creds.clientSecret;

class DesktopLoginManager {
  HttpServer? redirectServer;
  oauth2.Client? client;

  // Launch the URL in the browser using url_launcher
  Future<void> redirect(Uri authorizationUrl) async {
    var url = authorizationUrl.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  Future<Map<String, String>> listen() async {
    var request = await redirectServer!.first;
    var params = request.uri.queryParameters;
    await WindowToFront.activate(); // Using window_to_front package to bring the window to the front after successful login.
    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Authenticated! You can close this tab.');
    await request.response.close();
    await redirectServer!.close();
    redirectServer = null;
    return params;
  }
}

class DesktopOAuthManager extends DesktopLoginManager {
  DesktopOAuthManager() : super();

  Future<oauth2.Client> googleLoginRedirect() async {
    await redirectServer?.close();
    // Bind to an ephemeral port on localhost
    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = 'http://localhost:${redirectServer!.port}/auth';
    return await _getOAuth2Client(Uri.parse(redirectURL));
  }

  Future<List<dynamic>> login() async {
    oauth2.Client authenticatedHttpClient;
    Map<String, dynamic> userInfo;
    if (await isFirstLogin()) {
      authenticatedHttpClient = await googleLoginRedirect();
      await storeToken(authenticatedHttpClient.credentials.accessToken);
      await storeRefreshToken(authenticatedHttpClient.credentials.refreshToken!);
      await storeExpiryToken(authenticatedHttpClient.credentials.expiration!.toIso8601String());
      userInfo = await getUserInfo(authenticatedHttpClient);
    } else {
      String accessToken = await getValidAccessToken(await getClientFromStoredCredentials());
      String? refreshToken = await getRefreshToken();
      String? expirationToken = await getExpiryToken();
      authenticatedHttpClient = buildClientWithAccessAndRefreshTokens(
        accessToken: accessToken,
        refreshToken: refreshToken!,
        tokenEndpoint: Uri.parse('https://oauth2.googleapis.com/token'),
        clientId: clientId,
        clientSecret: clientSecret,
        expiration: DateTime.parse(expirationToken!), // Example expiration time
      );

      if (authenticatedHttpClient.credentials.accessToken != accessToken) {
        // The token was refreshed, store the new access token and expiration date
        await storeToken(authenticatedHttpClient.credentials.accessToken);
        await storeExpiryToken(authenticatedHttpClient.credentials.expiration!.toIso8601String());
      }

      userInfo = await getUserInfo(authenticatedHttpClient);
    }

    print("User Info: ${userInfo["name"]}");

    return [userInfo, authenticatedHttpClient];
  }

  Future<oauth2.Client> getClientFromStoredCredentials() async {
    // Retrieve stored access token, refresh token, etc.
    String? accessToken = await getAccessToken();
    String? refreshToken = await getRefreshToken();
    String? expiryToken = await getExpiryToken();

    if (accessToken == null || refreshToken == null || expiryToken == null) {
      throw Exception('No stored credentials found');
    }

    // Recreate the Credentials object
    final credentials = oauth2.Credentials(
      accessToken,
      refreshToken: refreshToken,
      expiration: DateTime.parse(expiryToken), // Convert expiration back to DateTime
      tokenEndpoint: Uri.parse(tokenEndpoint),
    );

    // Recreate the client from the stored credentials
    return oauth2.Client(credentials, identifier: clientId, secret: clientSecret);
  }

  Future<bool> isFirstLogin() async {
    String? savedRefreshToken = await getRefreshToken();
    String? savedAccessToken = await getAccessToken();
    String? expiryToken = await getExpiryToken();
    return (savedRefreshToken == null || savedAccessToken == null || expiryToken == null);
  }

  Future<String> getValidAccessToken(oauth2.Client client) async {
    if (client.credentials.isExpired) {
      // The access token is expired, refresh it using the refresh token
      String? savedRefreshToken = await getRefreshToken();
      if (savedRefreshToken != null) {
        return await refreshAccessToken(savedRefreshToken);
      } else {
        throw Exception('No refresh token found');
      }
    } else {
      // Token is still valid, use the current access token
      return client.credentials.accessToken;
    }
  }

  Future<String> refreshAccessToken(String refreshToken) async {
    // Prepare the request to Google's OAuth2 token endpoint
    final response = await http.post(
      Uri.parse(tokenEndpoint),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'client_id': clientId, // Your app's client ID
        'client_secret': clientSecret, // Your app's client secret
        'refresh_token': refreshToken, // The refresh token obtained previously
        'grant_type': 'refresh_token', // The grant type must be refresh_token
      },
    );

    // If the request is successful
    if (response.statusCode == 200) {
      final Map<String, dynamic> tokenResponse = json.decode(response.body);

      // Extract the new access token
      String newAccessToken = tokenResponse['access_token'];

      // Optionally store the new access token
      storeToken(newAccessToken);

      return newAccessToken;
    } else {
      throw Exception('Failed to refresh access token');
    }
  }

  Future<oauth2.Client> _getOAuth2Client(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      clientId,
      Uri.parse(authorizationEndpoint),
      Uri.parse(tokenEndpoint),
      httpClient: _JsonAcceptingHttpClient(),
      secret: clientSecret,
    );
    var authorizationUrl = grant.getAuthorizationUrl(redirectUrl, scopes: scopes);

    authorizationUrl = authorizationUrl.replace(queryParameters: {
      ...authorizationUrl.queryParameters,
      "access_type": "offline",
    });

    await redirect(authorizationUrl);
    var responseQueryParameters = await listen();
    var client = await grant.handleAuthorizationResponse(responseQueryParameters);

    return client;
  }
}

oauth2.Client buildClientWithAccessAndRefreshTokens({
  required String accessToken,
  required String refreshToken,
  required Uri tokenEndpoint,
  required String clientId,
  required String clientSecret,
  DateTime? expiration,
}) {
  // Create OAuth2 credentials using both access and refresh tokens
  final credentials = oauth2.Credentials(
    accessToken,
    refreshToken: refreshToken,
    expiration: expiration, // Optional, if known
    tokenEndpoint: tokenEndpoint,
  );

  // Build the client with credentials
  return oauth2.Client(
    credentials,
    identifier: clientId,
    secret: clientSecret,
    httpClient: http.Client(), // Use the default HTTP client
  );
}

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}

Future<Map<String, dynamic>> getUserInfo(oauth2.Client client) async {
  final response = await client.get(Uri.parse('https://www.googleapis.com/oauth2/v1/userinfo?alt=json'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body); // Parse the JSON response and return user data
  } else {
    throw Exception('Failed to load user info');
  }
}
