import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/data.dart';
import "package:googleapis/drive/v3.dart" as drive;

Future<void> saveFile(String fileId, String newContent) async {
  final authHeaders = await currentUser!.authHeaders;
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
  }
}
