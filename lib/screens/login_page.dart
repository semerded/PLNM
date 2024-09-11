import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/backend/local_file_handler.dart';
import 'package:keeper_of_projects/common/enum/conflict_type.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/backend.dart' as backend;
import 'package:keeper_of_projects/screens/about_page.dart';
import 'package:keeper_of_projects/screens/conflict_page.dart';
import 'package:keeper_of_projects/screens/home/home_page.dart';
import 'package:keeper_of_projects/icons/drive_icon.dart';

// ignore: camel_case_types
enum loginStatus { unset, loggedIn, notLoggedIn }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  loginStatus loggedIn = loginStatus.unset;
  late final AnimationController rotationLogoController;
  late final Animation<double> rotationAnimation;

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
            loggedIn = loginStatus.loggedIn;
          }
        });

        await backend.init();
        await backend.checkForConflict().then((conflict) async {
          if (conflict) {
            await Navigator.push(
              context,
              MaterialPageRoute<ConflictType>(
                builder: (context) => ConflictPage(
                  localDate: local_syncFileContent!,
                  cloudDate: syncDataContent!,
                ),
              ),
            ).then((conflictSolution) async {
              if (conflictSolution == ConflictType.local) {
                await getLocalFileData();
                backend.syncCloudFileData();
              } else {
                await backend.getCloudFileData();
                syncLocalFileData();
                DateTime now = DateTime.now();
                saveFile(syncFileData!.id!, DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString());
              }
            });
          } else {
            await backend.getCloudFileData();
            await onlyRepairLocalFiles();
            syncLocalFileData();
          }
        });
        syncSettings();
        fileSyncSystem.startSyncSystem();
        rotationLogoController.dispose();
        Navigator.push(
          context,
          MaterialPageRoute<bool>(
            builder: (context) => const HomePage(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // create animations
    rotationLogoController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    rotationAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: 0,
              end: 1,
            ).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
            weight: 2),
        TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: 0,
              end: 0,
            ).chain(
              CurveTween(curve: Curves.linear),
            ),
            weight: 2),
      ],
    ).animate(rotationLogoController);

    // sign in with google
    if (Platform.isAndroid || Platform.isIOS) {
      mobileAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: () {
        if (loggedIn == loginStatus.loggedIn) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "googleUserCircleAvatar",
                    child: GoogleUserCircleAvatar(
                      identity: currentUser!,
                    ),
                  ),
                  Container(
                    width: 5,
                  ),
                  RotationTransition(turns: rotationAnimation, child: const DriveIcon()),
                ],
              ),
              AdaptiveText(
                "Syncing Google Drive",
                fontWeight: FontWeight.w800,
                fontSize: 28,
              ),
            ],
          );
        } else if (loggedIn == loginStatus.notLoggedIn) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Palette.primary,
                    onPressed: () {
                      handleSignIn();
                    },
                    child: const Icon(Icons.login),
                  ),
                  Container(
                    width: 5,
                  ),
                  const DriveIcon(),
                ],
              ),
              AdaptiveText(
                "Sign In With Google",
                fontWeight: FontWeight.w800,
                fontSize: 28,
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<bool>(
                    builder: (context) => const AboutPage(),
                  ),
                ),
                label: AdaptiveText(
                  "Why Do I Have To Sign In With Google",
                  fontSize: 12,
                ),
                icon: const Icon(
                  Icons.info,
                  size: 24,
                  color: Palette.primary,
                ),
                style: ButtonStyle(
                  elevation: const WidgetStatePropertyAll(0),
                  backgroundColor: WidgetStatePropertyAll(Palette.bg),
                ),
              ),
            ],
          );
        } else {
          return const Center(
            child: DriveIcon(),
          );
        }
      }(),
    );
  }
}
