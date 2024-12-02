import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/cloud_file_handler.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/file_sync_system.dart';
import 'package:keeper_of_projects/backend/local_file_handler.dart';
import 'package:keeper_of_projects/common/animations/rotate_drive_logo.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/login/login_states/logged_in_syncing.dart';

class DownloadFromCloud extends StatefulWidget {
  const DownloadFromCloud({super.key});

  @override
  State<DownloadFromCloud> createState() => _DownloadFromCloudState();
}

class _DownloadFromCloudState extends State<DownloadFromCloud> with SingleTickerProviderStateMixin {
  late RotateDriveLogo rotateDriveLogo;

  void syncSettings() {
    if (settingsDataContent!["darkmode"]) {
      Palette.setDarkmode(true);
    }
  }

  @override
  void initState() {
    super.initState();
    rotateDriveLogo = RotateDriveLogo(this);
    getCloudFileData().then((value) {
      syncLocalFileData();
      FileSyncSystem.saveSyncTime();

      syncSettings();
      fileSyncSystem.startSyncSystem();
      rotateDriveLogo.dispose();

      projectsContent = projectsDataContent!["projects"];
      ideasContent = projectsDataContent!["ideas"];
      taskContent = taskDataContent!["task"];
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoggedInSyncing(
      rotateDriveLogo: rotateDriveLogo,
    );
  }
}
