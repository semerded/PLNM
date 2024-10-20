import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

Future<void> localWrite(String fileName, String content) async {
  final file = await localPath(fileName);
  await file.writeAsString(content);
  print("$fileName localy written");
}

Future<File> localPath(String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return File('$path/$fileName');
}

Future<String?> localRead(String fileName) async {
  try {
    final file = await localPath(fileName);
    return await file.readAsString();
  } catch (e) {
    print("local file $fileName not found, ${e}");
    return null;
  }
}

Future<void> getLocalFileData() async {
  projectsDataContent = await readOrRepairLocalFile(projectsFileName, projectsFileDefaultContent);
  taskDataContent = await readOrRepairLocalFile(taskFileName, taskFileDefaultContent);
  settingsDataContent = await readOrRepairLocalFile(settingsFileName, settingsFileDefaultContent);
  notesDataContent = await readOrRepairLocalFile(notesFileName, notesFileDefaultContent);
  categoryDataContent = List<String>.from(await readOrRepairLocalFile(categoryFileName, categoryFileDefaultContent));
  for (String category in categoryDataContent!) {
    categoryFilter[category] = true;
  }
}

Future<void> syncLocalFileData() async {
  await localWrite(projectsFileName, jsonEncode(projectsDataContent));
  await localWrite(taskFileName, jsonEncode(taskDataContent));
  await localWrite(settingsFileName, jsonEncode(settingsDataContent));
  await localWrite(categoryFileName, jsonEncode(categoryDataContent));
  await localWrite(notesFileName, jsonEncode(notesDataContent));
  DateTime now = DateTime.now();
  await localWrite(syncFileName, '["${DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString()}", "${deviceId ?? "noDeviceIdYet"}"]');
}

Future<void> onlyRepairLocalFiles() async {
  await readOrRepairLocalFile(projectsFileName, projectsFileDefaultContent);
  await readOrRepairLocalFile(taskFileName, taskFileDefaultContent);
  await readOrRepairLocalFile(settingsFileName, settingsFileDefaultContent);
  await readOrRepairLocalFile(categoryFileName, categoryFileDefaultContent);
  await readOrRepairLocalFile(notesFileName, notesFileDefaultContent);
}

Future<dynamic> readOrRepairLocalFile(String fileName, dynamic defaultContent) async {
  String? fileContent = await localRead(fileName);
  if (fileContent != null) {
    return jsonDecode(fileContent);
  } else {
    localWrite(fileName, defaultContent);
  }
}

Future<void> assignDeviceId() async {
  Uuid uuid = Uuid();
  deviceId = uuid.v4();
  local_syncFileContent![1] = deviceId!;
  DateTime now = DateTime.now();
  await localWrite(syncFileName, '["${DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString()}", "${deviceId ?? "noDeviceIdYet"}"]');
}
