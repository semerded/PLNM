import 'dart:convert';

import 'package:keeper_of_projects/backend/content/default_file_content.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/backend/local_file_handler.dart';
import 'package:keeper_of_projects/backend/validate_drive_data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:googleapis/drive/v3.dart' as drive;

Future init() async {
  // prepare drive api
  authHeaders = await currentUser!.authHeaders;
  authenticateClient = GoogleHttpClient(authHeaders!);
  driveApi = drive.DriveApi(authenticateClient!);

  await getOrRepairDriveFolders(driveApi!);
}

Future<bool> checkForConflict() async {
  await getOrRepairDriveSyncDataFile(driveApi!);
  await getOrRepairDriveFiles(driveApi!);

  drive.Media _media = await driveApi?.files.get(syncFileData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  syncDataContent = await utf8.decoder.bind(_media.stream).join();

  local_syncFileContent = await localRead(syncFileName);
  if (local_syncFileContent == null) {
    await localWrite(syncFileName, syncFileDefaultContent);
    return false;
  }

  if (local_syncFileContent == 'noSyncYet') {
    return false;
  }

  DateTime localTime = DateTime.parse(local_syncFileContent!);
  DateTime cloudTime = DateTime.parse(syncDataContent!);
  print(localTime);
  print(cloudTime);
  if (localTime.compareTo(cloudTime) > 0) {
    // 10 second of clearance
    Duration difference = localTime.difference(cloudTime);
    if (difference.inSeconds > 10) {
      return true;
    }
  }

  return false;
}

Future getCloudFileData() async {
  // fetch the content from the projectsFileData file
  drive.Media _media = await driveApi?.files.get(projectsFileData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  projectsDataContent = jsonSafeDecode(await utf8.decoder.bind(_media.stream).join());

  // fetch the content from the taskFileData file
  _media = await driveApi?.files.get(taskFileData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  taskDataContent = jsonSafeDecode(await utf8.decoder.bind(_media.stream).join());

  // fetch the content from the settingsFileData file
  _media = await driveApi?.files.get(settingsFileData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  settingsDataContent = jsonSafeDecode(await utf8.decoder.bind(_media.stream).join());

  _media = await driveApi?.files.get(categoryFileData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  categoryDataContent = List<String>.from(jsonSafeDecode(await utf8.decoder.bind(_media.stream).join()));

  for (String category in categoryDataContent!) {
    categoryFilter[category] = true;
  }
}

Future<void> syncCloudFileData() async {
  await saveFile(projectsFileData!.id!, jsonEncode(projectsDataContent));
  await saveFile(taskFileData!.id!, jsonEncode(taskDataContent));
  await saveFile(settingsFileData!.id!, jsonEncode(settingsDataContent));
  await saveFile(categoryFileData!.id!, jsonEncode(categoryDataContent));
  DateTime now = DateTime.now();
  await saveFile(syncFileData!.id!, DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString());
}

dynamic jsonSafeDecode(String source) {
  var decoded = jsonDecode(source);
  if (decoded is String) {
    decoded = jsonDecode(decoded);
  }
  return decoded;
}
