import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/google_api/http_client.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/google_api/local_file_handler.dart';

void createFile(String fileName) async {
  final authHeaders = await currentUser!.authHeaders;
  final authenticateClient = GoogleHttpClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);

  var file = await localPath;
  var stream = file.openRead();
  var media = drive.Media(stream, file.lengthSync());

  var driveFile = drive.File();
  driveFile.name = fileName;

  try {
    var response = await driveApi.files.create(
      driveFile,
      uploadMedia: media,
    );
  } catch (e) {
    // TODO add message to snackbar
  }
}

void createFolder() async {
  final authHeaders = await currentUser!.authHeaders;
  final authenticateClient = GoogleHttpClient(authHeaders);
  final driveApi = drive.DriveApi(authenticateClient);
}
