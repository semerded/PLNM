import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/backend/validate_drive_data.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:googleapis/drive/v3.dart' as drive;


void init() async {
  authHeaders = await currentUser!.authHeaders;
  authenticateClient = GoogleHttpClient(authHeaders!);
  driveApi = drive.DriveApi(authenticateClient!);
  
  checkAndRepairDriveFiles(driveApi!);
}
