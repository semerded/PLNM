import 'dart:convert';

import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/backend/validate_drive_data.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:googleapis/drive/v3.dart' as drive;

Future<String> init() async {
  // prepare drive api
  authHeaders = await currentUser!.authHeaders;
  authenticateClient = GoogleHttpClient(authHeaders!);
  driveApi = drive.DriveApi(authenticateClient!);

  // check if all files are available in drive and fetch them
  // if they are not available they will be created containing the default file content
  String callback = await checkAndRepairDriveFiles(driveApi!);

  // fetch the content from the userdata file
  drive.Media _media = await driveApi?.files.get(userData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  userDataContent = jsonDecode(await utf8.decoder.bind(_media.stream).join());

  // fetch the content from the settingsdata file
  _media = await driveApi?.files.get(settingsData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  settingsDataContent = jsonDecode(await utf8.decoder.bind(_media.stream).join());

  // return the callback
  return callback;
}
