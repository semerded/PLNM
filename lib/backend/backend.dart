import 'dart:convert';

import 'package:googleapis/drive/v3.dart' as drive;
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/http_client.dart';
import 'package:keeper_of_projects/backend/json_save_decode.dart';
import 'package:keeper_of_projects/backend/local_file_handler.dart';
import 'package:keeper_of_projects/backend/validate_drive_data.dart';
import 'package:keeper_of_projects/data.dart';

Future<void> initApi() async {
  //& prepare drive API
  authHeaders = await currentUser!.authHeaders;
  authenticateClient = GoogleHttpClient(authHeaders!);
  driveApi = drive.DriveApi(authenticateClient!);
}

Future<bool> isSyncNeeded() async {
  await _getCloudSyncFileContent();

  String? checkLocal_syncFileContent = await localRead(syncFileName);
  if (checkLocal_syncFileContent == null) {
    await localWrite(syncFileName, syncFileDefaultContent);
    local_syncFileContent = List<String>.from(jsonDecode(syncFileDefaultContent));
    await assignDeviceId();
    return true;
  }
  local_syncFileContent = List<String>.from(jsonDecode(checkLocal_syncFileContent));
  print(local_syncFileContent![1]);
  print(syncDataContent![1]);

  if (local_syncFileContent![1] == 'noDeviceIdYet') {
    assignDeviceId();
    return true;
  }

  if (local_syncFileContent![0] == 'noSyncYet' || syncDataContent![0] == 'noSyncYet') {
    return true;
  }

  deviceId = local_syncFileContent![1];
  if (deviceId == syncDataContent![1]) {
    return false;
  }
  return true;
}

Future<void> _getCloudSyncFileContent() async {
  await getOrRepairDriveSyncDataFile(driveApi!);

  drive.Media _media = await driveApi?.files.get(syncFileData!.id!, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
  syncDataContent = List<String>.from(jsonSafeDecode(await utf8.decoder.bind(_media.stream).join()));
}

Future<bool> checkForConflict() async {
  if (local_syncFileContent![0] == 'noSyncYet') {
    return false;
  }
  DateTime localTime = DateTime.parse(local_syncFileContent![0]);
  DateTime cloudTime = DateTime.parse(syncDataContent![0]);

  if (localTime.compareTo(cloudTime) > 0) {
    // 10 second of clearance
    Duration difference = localTime.difference(cloudTime);
    if (difference.inSeconds > 10) {
      return true;
    }
  }

  return false;
}
