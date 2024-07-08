//^ when app is opened: check if file exists in onedrive account

import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/google_api/http_client.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/file_data.dart';

Future<void> fileExists() async {
  final Map<String, String> authHeaders = await currentUser!.authHeaders;
  final GoogleHttpClient authenticateClient = GoogleHttpClient(authHeaders);
  final drive.DriveApi driveApi = drive.DriveApi(authenticateClient);

  print(await checkIfFolderExists(parentFolderName, driveApi));
  print(await checkIfFolderExists(folderName, driveApi));
  print(await checkIfFileExists(fileName, driveApi));
  print(await checkIfFileExists(settingsData, driveApi));
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
