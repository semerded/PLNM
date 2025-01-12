import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/data.dart';
import "package:googleapis/drive/v3.dart" as drive;

Future<bool> saveFile(String fileId, String newContent) async {
  dynamic authHeaders;
  try {
    authHeaders = await currentUser!.authHeaders;
  } catch (e) {
    print('Error getting auth headers: $e');
    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('Error: failed to connect to server')),
    );
    return false;
  }
  final authenticateClient = GoogleHttpClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);

  var media = drive.Media(
    Stream.value(utf8.encode(newContent)),
    utf8.encode(newContent).length,
  );

  try {
    var response = await driveApi.files.update(
      drive.File(),
      fileId,
      uploadMedia: media,
    );
    print('File updated: ${response.name} with ID: ${response.id}');
  } catch (e) {
    print('Error updating file: $e');
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text('Error updating file: $e')),
    );
    return false;
  }
  return true;
}
