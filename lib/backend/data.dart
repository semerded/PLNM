import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/backend/content/default_file_content.dart' as content;


const String fileName = "__user-data.json";
const String fileDefaultContent = content.data;
const String settingsName = "__user-settings.json";
const String settingsDefaultContent = content.settings;
const String parentFolderName = "com.semerded";
const String folderName = "keeper-of-projects";

drive.File? appFolder;
drive.File? userData;
Map<String, dynamic>? userDataContent;
drive.File? settingsData;
Map<String, dynamic>? settingsDataContent;

Map<String, String>? authHeaders;
GoogleHttpClient? authenticateClient;
drive.DriveApi? driveApi;

//^ file data for readme file
const String readmeName = "README.txt";
const String readmeContent = content.readme;

bool settingsDataNeedsSync = false;