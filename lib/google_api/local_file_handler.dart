import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> write(String text) async {
  final file = await localPath;
  await file.writeAsString(text);
}

Future<File> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  return File('$path/my_file.txt');
}

Future<String> read() async {
  try {
    final file = await localPath;
    return await file.readAsString();
  } catch (e) {
    return "";
  }
}
