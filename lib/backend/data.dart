import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/backend/content/default_file_content.dart' as defaultContent;

const String projectsFileName = "project-data.json";
const String projectsFileDefaultContent = defaultContent.projectsData;
const String settingsFileName = "settings-data.json";
const String settingsFileDefaultContent = defaultContent.settings;
const String categoryFileName = "category-data.json";
const String categoryFileDefaultContent = defaultContent.categoryData;
const String parentFolderName = "com.semerded";
const String folderName = "keeper-of-projects";

drive.File? appFolder;
drive.File? projectsFileData;
Map? projectsDataContent;
drive.File? settingsFileData;
Map? settingsDataContent;
drive.File? categoryFileData;
List<String>? categoryDataContent;

Map<String, String>? authHeaders;
GoogleHttpClient? authenticateClient;
drive.DriveApi? driveApi;

//^ file data for readme file
const String readmeName = "README.txt";
const String readmeContent = defaultContent.readme;

bool settingsDataNeedsSync = false;
bool categoryDataNeedSync = false;
