import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/cloud_file_handler.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/file_sync_system.dart';
import 'package:keeper_of_projects/backend/google_api/desktop_account_link.dart';
import 'package:keeper_of_projects/backend/google_api/desktop_login.dart';
import 'package:keeper_of_projects/backend/local_file_handler.dart';
import 'package:keeper_of_projects/backend/validate_drive_data.dart';
import 'package:keeper_of_projects/common/enum/conflict_type.dart';
import 'package:keeper_of_projects/common/icons/drive_icon.dart';
import 'package:keeper_of_projects/common/pages/conflict_page.dart';
import 'package:keeper_of_projects/common/widgets/rotate_drive_logo.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/backend.dart' as backend;
import 'package:keeper_of_projects/desktop/pages/home/home_page.dart';
import 'package:keeper_of_projects/desktop/pages/login/login_states/logged_in_check_sync.dart';
import 'package:keeper_of_projects/desktop/pages/login/login_states/logged_in_syncing.dart';
import 'package:keeper_of_projects/desktop/pages/login/login_states/not_logged_in.dart';

// ignore: camel_case_types
enum loginStatus { unset, loggedInCheckSync, loggedInSyncing, notLoggedIn }

class DesktopLoginPage extends StatefulWidget {
  const DesktopLoginPage({super.key});

  @override
  State<DesktopLoginPage> createState() => _DesktopLoginPageState();
}

class _DesktopLoginPageState extends State<DesktopLoginPage> with SingleTickerProviderStateMixin {
  loginStatus loggedIn = loginStatus.unset;
  late final RotateDriveLogo rotateDriveLogo;

  void desktopAuth() {
    DesktopOAuthManager().login().then((user) async {
      setState(() {
        currentUser = GoogleSignInAccountAdapter(DesktopGoogleSignInAccount.fromJson(user[0], user[1]));
        if (currentUser != null) {
          loggedIn = loginStatus.loggedInCheckSync;
        }
      });
      await getData();
    });
  }

  Future<void> getData() async {
    await backend.initApi();
    await backend.isSyncNeeded().then((isSyncNeeded) async {
      if (!isSyncNeeded) {
        // sync is not needed because local data is up-to date
        await getLocalFileData();
      } else {
        setState(() {
          loggedIn = loginStatus.loggedInSyncing;
        });
        await backend.checkForConflict().then((isConflict) async {
          if (isConflict) {
            await Navigator.push(
              context,
              MaterialPageRoute<ConflictType>(
                builder: (context) => ConflictPage(
                  localDate: local_syncFileContent![0],
                  cloudDate: syncDataContent![0],
                ),
              ),
            ).then((conflictSolution) async {
              if (conflictSolution == ConflictType.local) {
                await getLocalFileData();
                getOrRepairDriveFiles(driveApi!);

                syncCloudFileData();
              } else {
                await getOrRepairDriveFiles(driveApi!);
                await getCloudFileData();
                syncLocalFileData();
                FileSyncSystem.saveSyncTime();
              }
            });
          } else {
            await getOrRepairDriveFiles(driveApi!);

            await getCloudFileData();
            await onlyRepairLocalFiles();
            syncLocalFileData();
          }
        });
      }
    });
    syncSettings();
    fileSyncSystem.startSyncSystem();
    rotateDriveLogo.dispose();

    projectsContent = projectsDataContent!["projects"];
    ideasContent = projectsDataContent!["ideas"];
    taskContent = taskDataContent!["task"];

    Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void syncSettings() {
    if (settingsDataContent!["darkmode"]) {
      Palette.setDarkmode(true);
    }
  }

  @override
  void initState() {
    super.initState();

    // create animations
    rotateDriveLogo = RotateDriveLogo(this);

    // sign in with google
    desktopAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: () {
        if (loggedIn == loginStatus.loggedInCheckSync) {
          LoggedInCheckSync(rotateDriveLogo: rotateDriveLogo);
        } else if (loggedIn == loginStatus.loggedInSyncing) {
          LoggedInSyncing(rotateDriveLogo: rotateDriveLogo);
        } else if (loggedIn == loginStatus.notLoggedIn) {
          const NotLoggedIn();
        } else {
          return const Center(
            child: DriveIcon(),
          );
        }
      }(),
    );
  }
}
