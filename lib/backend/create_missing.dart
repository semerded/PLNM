import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;

void createFile(String fileName, String defaultFileContent, drive.DriveApi driveApi) async {
  var fileMetadata = drive.File();
    fileMetadata.name = fileName;

    var media = drive.Media(
      Stream.value(utf8.encode(defaultFileContent)),
      utf8.encode(defaultFileContent).length,
    );

    try {
      var response = await driveApi.files.create(
        fileMetadata,
        uploadMedia: media,
      );
      print('File created: ${response.name} with ID: ${response.id}');
    } catch (e) {
      print('Error creating file: $e');
    }
}

void createFolder(String folderName, drive.DriveApi driveApi) async {
  drive.File folder = drive.File();
  folder.name = folderName;
  folder.mimeType = 'application/vnd.google-apps.folder';

  try {
    var response = await driveApi.files.create(folder);
    print('Folder created: ${response.name} with ID: ${response.id}');
  } catch (e) {
    print('Error creating folder: $e');
  }
}
