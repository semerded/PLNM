import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keeper_of_projects/backend/cloud_file_handler.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/file_sync_system.dart';
import 'package:keeper_of_projects/backend/local_file_handler.dart';
import 'package:keeper_of_projects/common/enum/conflict_type.dart';
import 'package:keeper_of_projects/common/icons/drive_icon.dart';
import 'package:keeper_of_projects/common/pages/conflict_page.dart';
import 'package:keeper_of_projects/common/widgets/rotate_drive_logo.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/validate_drive_data.dart';
import 'package:keeper_of_projects/backend/backend.dart' as backend;
import 'package:keeper_of_projects/mobile/pages/home/home_page.dart';
import 'package:keeper_of_projects/mobile/pages/login/login_states/logged_in_check_sync.dart';
import 'package:keeper_of_projects/mobile/pages/login/login_states/logged_in_syncing.dart';
import 'package:keeper_of_projects/mobile/pages/login/login_states/not_logged_in.dart';

// ignore: camel_case_types
enum loginStatus { unset, loggedInCheckSync, loggedInSyncing, notLoggedIn }

class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({super.key});

  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> with SingleTickerProviderStateMixin {
  loginStatus loggedIn = loginStatus.unset;
  late final RotateDriveLogo rotateDriveLogo;

  void syncSettings() {
    if (settingsDataContent!["darkmode"]) {
      Palette.setDarkmode(true);
    }
  }

  void mobileAuth() {
    googleSignIn.signInSilently();

    googleSignIn.isSignedIn().then(
          (value) => setState(() {
            if (!value) {
              loggedIn = loginStatus.notLoggedIn;
            }
          }),
        );

    googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount? account) async {
        setState(() {
          currentUser = account;
          if (currentUser != null) {
            loggedIn = loginStatus.loggedInCheckSync;
          }
          getData();
        });
      },
    );
  }

  Future<void> getData() async {
    await backend.initApi();
    await backend.isSyncNeeded().then((isSyncNeeded) async {
      if (!isSyncNeeded) {
        // sync is not needed because local data is up-to date
        await getLocalFileData();
        getOrRepairDriveFolders(driveApi!).then((value) {
          getOrRepairDriveFiles(driveApi!);
        });
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
                getOrRepairDriveFolders(driveApi!).then((value) {
                  getOrRepairDriveFiles(driveApi!);
                });

                syncCloudFileData();
              } else {
                await getOrRepairDriveFolders(driveApi!);
                await getOrRepairDriveFiles(driveApi!);
                await getCloudFileData();
                syncLocalFileData();
                FileSyncSystem.saveSyncTime();
              }
            });
          } else {
            await getOrRepairDriveFolders(driveApi!);
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

    // everySecondUpdate = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   setState(() {
    //     dateTimeNow = DateTime.now();
    //   });
    // }); //#001

    Navigator.push(
      context,
      MaterialPageRoute<bool>(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // create animations
    rotateDriveLogo = RotateDriveLogo(this);
    mobileAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: () {
        if (loggedIn == loginStatus.loggedInCheckSync) {
          return LoggedInCheckSync(rotateDriveLogo: rotateDriveLogo);
        } else if (loggedIn == loginStatus.loggedInSyncing) {
          return LoggedInSyncing(rotateDriveLogo: rotateDriveLogo);
        } else if (loggedIn == loginStatus.notLoggedIn) {
          return const NotLoggedIn();
        } else {
          return const Center(
            child: DriveIcon(),
          );
        }
      }(),
    );
  }
}
