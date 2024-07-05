import "package:googleapis/drive/v3.dart" as drive;
import "package:keeper_of_projects/data.dart";
import "package:http/http.dart";
import 'package:http/io_client.dart';


Future<List<drive.File>?> _searchFiles(String query) async {
    if (currentUser == null) {
      return null;
    }
    
    final authHeaders = await currentUser!.authHeaders;
    final authenticateClient = GoogleHttpClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    try {
      drive.FileList result = await driveApi.files.list(
        q: "name = '$query'",
        spaces: 'drive',
        $fields: "files(id, name)",
      );
      return result.files;
    } catch (e) {
      print('Error searching files: $e');
      return null;
    }
  }

  Future<void> _overwriteFile(String fileId, File newFile) async {
    if (_currentUser == null) {
      return;
    }
    
    final authHeaders = await _currentUser!.authHeaders;
    final authenticateClient = GoogleHttpClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    var stream = newFile.openRead();
    var media = drive.Media(stream, newFile.lengthSync());

    var driveFile = drive.File();

    try {
      var response = await driveApi.files.update(
        driveFile,
        fileId,
        uploadMedia: media,
      );
      print('File overwritten: ${response.name}');
    } catch (e) {
      print('Error overwriting file: $e');
    }
  }