import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<void> storeToken(String accessToken) async {
  await storage.write(key: 'access_token', value: accessToken);
}

Future<void> storeRefreshToken(String refreshToken) async {
  await storage.write(key: 'refresh_token', value: refreshToken);
}

Future<void> storeExpiryToken(String expirationDate) async {
  await storage.write(key: 'expiry_token', value: expirationDate);
}

Future<String?> getAccessToken() async {
  return await storage.read(key: 'access_token');
}

Future<String?> getRefreshToken() async {
  return await storage.read(key: 'refresh_token');
}

Future<String?> getExpiryToken() async {
  return await storage.read(key: 'expiry_token');
}

Future<void> logout() async {
  await storage.delete(key: 'access_token');
  await storage.delete(key: 'refresh_token');
  await storage.delete(key: 'expiry_token');
}
