import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;

Future<drive.File?> createFile(String projectsFileName, String defaultFileContent, drive.DriveApi driveApi, [String? parentFolderId]) async {
  drive.File fileMetadata = drive.File();
  fileMetadata.name = projectsFileName;
  if (parentFolderId != null) {
    fileMetadata.parents = [parentFolderId];
  }

  drive.Media media = drive.Media(
    Stream.value(utf8.encode(defaultFileContent)),
    utf8.encode(defaultFileContent).length,
  );

  try {
    var response = await driveApi.files.create(
      fileMetadata,
      uploadMedia: media,
    );
    print('File created: ${response.name} with ID: ${response.id}');
    return response;
  } catch (e) {
    print('Error creating file: $e');
    return null;
  }
}

Future<drive.File?> createFolder(String folderName, drive.DriveApi driveApi, [String? parentFolderId]) async {
  drive.File folder = drive.File();
  folder.name = folderName;
  folder.mimeType = 'application/vnd.google-apps.folder';
  if (parentFolderId != null) {
    folder.parents = [parentFolderId];
  }

  try {
    var response = await driveApi.files.create(folder);

    print('Folder created: ${response.name} with ID: ${response.id}');
    return response;
  } catch (e) {
    print('Error creating folder: $e');
    return null;
  }
}
