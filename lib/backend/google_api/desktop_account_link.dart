import 'package:google_sign_in/google_sign_in.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class DesktopGoogleSignInAccount {
  final String displayName;
  final String email;
  final String id;
  final String photoUrl;
  final oauth2.Client oauthClient; // Store the OAuth client

  DesktopGoogleSignInAccount({
    required this.displayName,
    required this.email,
    required this.id,
    required this.photoUrl,
    required this.oauthClient,
  });

  // Factory constructor to create the object from the JSON response
  factory DesktopGoogleSignInAccount.fromJson(Map<String, dynamic> json, oauth2.Client client) {
    return DesktopGoogleSignInAccount(
      displayName: json['name'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      photoUrl: json['picture'] ?? '',
      oauthClient: client,
    );
  }

  @override
  String toString() {
    return 'GoogleSignInAccount: $displayName, $email';
  }

  @override
  Future<Map<String, String>> get authHeaders async {
    return {
      'Authorization': 'Bearer ${oauthClient.credentials.accessToken}',
    };
  }
}

class GoogleSignInAccountAdapter implements GoogleIdentity {
  final DesktopGoogleSignInAccount account;

  GoogleSignInAccountAdapter(this.account);

  @override
  String get displayName => account.displayName ?? '';

  @override
  String get email => account.email;

  @override
  String get id => account.id;

  @override
  String get photoUrl => account.photoUrl ?? '';

  @override
  // TODO: implement serverAuthCode
  String? get serverAuthCode => throw UnimplementedError();

  @override
  Future<Map<String, String>> get authHeaders => account.authHeaders;
}
