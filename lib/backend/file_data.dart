import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/google_api/http_client.dart';
import 'package:keeper_of_projects/backend/readme_content.dart' as readme;


const String fileName = "__user-data.json";
const String fileDefaultContent = "{}";
const String settingsName = "__user-settings.json";
const String settingsDefaultContent = "{darkmode = false}";
const String parentFolderName = "com.semerded";
const String folderName = "keeper-of-projects";

drive.File? appFolder;
drive.File? userData;
drive.File? settingsData;

Map<String, String>? authHeaders;
GoogleHttpClient? authenticateClient;
drive.DriveApi? driveApi;

//^ file data for readme file
const String readmeName = "README.txt";
const String readmeContent = readme.content;