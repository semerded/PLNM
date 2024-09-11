import 'dart:async';
import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/backend/local_file_handler.dart';

class FileSyncSystem {
  Timer? _syncSystemTimer;
  Map _syncList = {};

  void startSyncSystem() {
    _syncSystemTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => _syncSystem(),
    );
  }

  void stopSyncSystem() {
    _syncSystemTimer!.cancel();
  }

  Future<void> syncFile(drive.File file, dynamic newContent) async {
    await localWrite(file.name!, newContent);
    DateTime now = DateTime.now();
    await localWrite(syncFileName, DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString());
    _syncList[file] = newContent;
  }

  void _syncSystem() {
    if (_syncList.isNotEmpty) {
      for (final entry in _syncList.entries) {
        saveFile(entry.key.id!, jsonEncode(entry.value));
        _syncList.remove(entry.key);
      }
      DateTime now = DateTime.now();
      saveFile(syncFileData!.id!, DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString());
    }
  }
}
