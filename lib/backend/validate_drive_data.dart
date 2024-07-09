//^ when app is opened: check if file exists in onedrive account

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/create_missing.dart';
import 'package:keeper_of_projects/backend/file_data.dart';

Future<void> checkAndRepairDriveFiles(drive.DriveApi driveApi) async {
  drive.File? parentAppFolder = await getFolder(parentFolderName, driveApi);
  print(parentAppFolder);
  if (parentAppFolder == null || parentAppFolder.name != parentFolderName) {
    // repair if non existing
    parentAppFolder = await createFolder(parentFolderName, driveApi);
    await createFile(readmeName, readmeContent, driveApi, parentAppFolder!.id);
    print(true);
  }

  appFolder = await getFolder(folderName, driveApi);
  if (appFolder == null || appFolder!.name != folderName) {
    appFolder = await createFolder(folderName, driveApi, parentAppFolder.id);
    print(true);
  }

  userData = await getFile(fileName, driveApi);
  if (userData == null || appFolder!.name != fileName) {
    userData = await createFile(fileName, fileDefaultContent, driveApi, appFolder!.id);
    print(true);
  }

  settingsData = await getFile(settingsName, driveApi);
  if (settingsData == null || settingsData!.name != settingsName) {
    settingsData = await createFile(settingsName, settingsDefaultContent, driveApi, appFolder!.id);
    print(true);
  }
}

Future<drive.File?> getFile(String fileName, drive.DriveApi driveApi, [String? parentFolderName]) async {
  try {
    drive.FileList result = await driveApi.files.list(
      q: "name = '$fileName'",
      spaces: 'drive',
      $fields: "files(id, name)",
    );

    if (result.files != null && result.files!.isNotEmpty) {
      return result.files?.first;
    }
    return null;
  } catch (e) {
    print('Error checking if file exists: $e');
    return null;
  }
}

Future<drive.File?> getFolder(String folderName, drive.DriveApi driveApi, [String? parentFolderName]) async {
  try {
    drive.FileList result = await driveApi.files.list(
      q: "mimeType = 'application/vnd.google-apps.folder' and name = '$folderName'",
      spaces: 'drive',
      $fields: "files(id, name)",
    );

    if (result.files != null && result.files!.isNotEmpty) {
      return result.files?.first;
    }
    return null;
  } catch (e) {
    print('Error checking if file exists: $e');
    return null;
  }
}
