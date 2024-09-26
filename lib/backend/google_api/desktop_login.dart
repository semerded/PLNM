import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:keeper_of_projects/backend/google_api/desktop_client_creds.dart' as hidden_creds;
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

  Future<List<dynamic>> login() async {
    await redirectServer?.close();
    // Bind to an ephemeral port on localhost
    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectURL = 'http://localhost:${redirectServer!.port}/auth';
    var authenticatedHttpClient = await _getOAuth2Client(Uri.parse(redirectURL));

    var userInfo = await _getUserInfo(authenticatedHttpClient);
    print("User Info: ${userInfo["name"]}");

    return [userInfo, authenticatedHttpClient];
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

class _JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}

Future<Map<String, dynamic>> _getUserInfo(oauth2.Client client) async {
  final response = await client.get(Uri.parse('https://www.googleapis.com/oauth2/v1/userinfo?alt=json'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body); // Parse the JSON response and return user data
  } else {
    throw Exception('Failed to load user info');
  }
}
