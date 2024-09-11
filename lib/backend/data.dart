// ignore_for_file: non_constant_identifier_names

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/file_sync_system.dart';
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/backend/content/default_file_content.dart' as defaultContent;

FileSyncSystem fileSyncSystem = FileSyncSystem();

const String syncFileName = "sync-data.json";
const String syncFileDefaultContent = defaultContent.syncData;
const String projectsFileName = "project-data.json";
const String projectsFileDefaultContent = defaultContent.projectsData;
const String todoFileName = "todo-data.json";
const String todoFileDefaultContent = defaultContent.todoData;
const String settingsFileName = "settings-data.json";
const String settingsFileDefaultContent = defaultContent.settings;
const String categoryFileName = "category-data.json";
const String categoryFileDefaultContent = defaultContent.categoryData;
const String parentFolderName = "com.semerded";
const String folderName = "keeper-of-projects";

drive.File? appFolder;
drive.File? syncFileData;
String? syncDataContent;
drive.File? projectsFileData;
Map? projectsDataContent;
drive.File? todoFileData;
Map? todoDataContent;
drive.File? settingsFileData;
Map? settingsDataContent;
drive.File? categoryFileData;
List<String>? categoryDataContent;

//^ local file data
String? local_syncFileContent;
Map? local_projectsDataContent;
Map? local_todoDataContent;
Map? local_settingsDataContent;
List<String>? local_categoryDataContent;

Map<String, String>? authHeaders;
GoogleHttpClient? authenticateClient;
drive.DriveApi? driveApi;

//^ file data for readme file
const String readmeName = "README.txt";
const String readmeContent = defaultContent.readme;

bool settingsDataNeedsSync = false;
bool categoryDataNeedSync = false;
