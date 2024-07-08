import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/google_api/http_client.dart';


const String fileName = "__user-data.json";
const String fileNameDefaultContent = "{}";
const String settingsData = "__user-settings.json";
const String settingsDataDefaultContent = "{darkmode = false}";
const String parentFolderName = "com.semerded";
const String folderName = "keeper-of-projects";

drive.File? userData;
drive.File? userSettings;

Map<String, String>? authHeaders;
GoogleHttpClient? authenticateClient;
drive.DriveApi? driveApi;