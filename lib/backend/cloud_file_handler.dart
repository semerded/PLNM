import 'dart:convert';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/file_sync_system.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/backend/json_save_decode.dart';
import 'package:keeper_of_projects/backend/validate_drive_data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';

Future getCloudFileData() async {
  await getOrRepairDriveFiles(driveApi!);
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

  _media = await driveApi?.files.get(notesFileData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  notesDataContent = List.from(jsonSafeDecode(await utf8.decoder.bind(_media.stream).join()));

  for (String category in categoryDataContent!) {
    categoryFilter[category] = true;
  }
}

Future<void> syncCloudFileData() async {
  await saveFile(projectsFileData!.id!, jsonEncode(projectsDataContent));
  await saveFile(taskFileData!.id!, jsonEncode(taskDataContent));
  await saveFile(settingsFileData!.id!, jsonEncode(settingsDataContent));
  await saveFile(categoryFileData!.id!, jsonEncode(categoryDataContent));
  await saveFile(notesFileData!.id!, jsonEncode(notesDataContent));
  FileSyncSystem.saveSyncTime();
}
