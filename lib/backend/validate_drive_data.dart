//^ when app is opened: check if file exists in onedrive account

import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/google_api/http_client.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/file_data.dart';

Future<void> fileExists() async {
  final authHeaders = await currentUser!.authHeaders;
  final authenticateClient = GoogleHttpClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);

  try {
    await driveApi.files.list(
      q: "mimeType = 'application/vnd.google-apps.folder' and name contains $parentFolderName'",
      spaces: 'drive',
      $fields: "files(id, name)",
    );
  } catch (e) {
    // failed to find parent folder
    // TODO show error in snackbar
  }
  try {
      await driveApi.files.list(
      q: "mimeType = 'application/vnd.google-apps.folder' and name contains $folderName'",
      spaces: 'drive',
      $fields: "files(id, name)",
    );
  } catch (e) {
    // failed to find app folder
    // TODO show error in snackbar
  }
  try {
    drive.FileList _userData = await driveApi.files.list(
      q: "name = '$fileName'",
      spaces: 'drive',
      $fields: "files(id, name)",
    );
    userData = _userData.files?.first;
    
  } catch (e) {
    // failed to find app data
    // TODO show error in snackbar
  }
  try {
    drive.FileList _userSettings = await driveApi.files.list(
      q: "name = '$settingsData'",
      spaces: 'drive',
      $fields: "files(id, name)",
    );
    userSettings = _userSettings.files?.first;
  } catch (e) {
    // failed to find app data
    // TODO show error in snackbar
  }
}

