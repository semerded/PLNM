import 'package:googleapis/drive/v3.dart' as drive;


const String fileName = "__user-data.json";
const String settingsData = "__user-settings.json";
const String parentFolderName = "com.semerded";
const String folderName = "keeper-of-projects";

drive.File? userData;
drive.File? userSettings;