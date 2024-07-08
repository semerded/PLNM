//^ when app is opened: check if file exists in onedrive account

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/create_missing.dart';
import 'package:keeper_of_projects/backend/file_data.dart';

Future<void> checkAndRepairDriveFiles(drive.DriveApi driveApi) async {
  if (!await checkIfFolderExists(parentFolderName, driveApi)) {
    // repair if non existing
    createFolder(parentFolderName, driveApi);
    print(true);
  }
  if (!await checkIfFolderExists(folderName, driveApi)) {
    createFolder(folderName, driveApi);
    print(true);
  }
  if (!await checkIfFileExists(fileName, driveApi)) {
    createFile(fileName, fileNameDefaultContent, driveApi);
    print(true);
  }
  if (!await checkIfFileExists(settingsData, driveApi)) {
    createFile(settingsData, settingsDataDefaultContent, driveApi);
    print(true);
  }
}

Future<bool> checkIfFileExists(String fileName, drive.DriveApi driveApi) async {
  try {
    drive.FileList result = await driveApi.files.list(
      q: "name = '$fileName'",
      spaces: 'drive',
      $fields: "files(id, name)",
    );

    if (result.files != null && result.files!.isNotEmpty) {
      return result.files?.first.name == folderName;
    }
    return false;
  } catch (e) {
    print('Error checking if file exists: $e');
    return false;
  }
}

Future<bool> checkIfFolderExists(String folderName, drive.DriveApi driveApi) async {
  try {
    drive.FileList result = await driveApi.files.list(
      q: "mimeType = 'application/vnd.google-apps.folder' and name = '$folderName'",
      spaces: 'drive',
      $fields: "files(id, name)",
    );

    if (result.files != null && result.files!.isNotEmpty) {
      return result.files?.first.name == folderName;
    }
    return false;
  } catch (e) {
    print('Error checking if file exists: $e');
    return false;
  }
}
