//^ when app is opened: check if file exists in onedrive account

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/create_missing.dart';
import 'package:keeper_of_projects/backend/data.dart';

Future<String> checkAndRepairDriveFiles(drive.DriveApi driveApi) async {
  drive.File? parentAppFolder = await getFolder(parentFolderName, driveApi);
  if (parentAppFolder == null || parentAppFolder.name != parentFolderName) {
    // repair if non existing
    parentAppFolder = await createFolder(parentFolderName, driveApi);
    await createFile(readmeName, readmeContent, driveApi, parentAppFolder!.id);
  }

  appFolder = await getFolder(folderName, driveApi);
  if (appFolder == null || appFolder!.name != folderName) {
    appFolder = await createFolder(folderName, driveApi, parentAppFolder.id);
  }

  projectsFileData = await getFile(projectsFileName, driveApi);
  if (projectsFileData == null || projectsFileData!.name != projectsFileName) {
    projectsFileData = await createFile(projectsFileName, projectsFileDefaultContent, driveApi, appFolder!.id);
  }

  settingsFileData = await getFile(settingsFileName, driveApi);
  if (settingsFileData == null || settingsFileData!.name != settingsFileName) {
    settingsFileData = await createFile(settingsFileName, settingsFileDefaultContent, driveApi, appFolder!.id);
  }

  categoryFileData = await getFile(categoryFileName, driveApi);
  if (categoryFileData == null || categoryFileData!.name != categoryFileName) {
    categoryFileData = await createFile(categoryFileName, categoryFileDefaultContent, driveApi, appFolder!.id);
  }

  return "Files synced with Google Drive";
}

Future<drive.File?> getFile(String projectsFileName, drive.DriveApi driveApi, [String? parentFolderName]) async {
  try {
    drive.FileList result = await driveApi.files.list(
      q: "name = '$projectsFileName'",
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
