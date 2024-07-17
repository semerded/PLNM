import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/backend.dart' as backend;
import 'package:keeper_of_projects/pages/home.dart';
import 'package:keeper_of_projects/widgets/icons/drive_icon.dart';

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
    googleSignIn.signInSilently();

    googleSignIn.isSignedIn().then(
          (value) => setState(() {
            if (value) {
              loggedIn = loginStatus.loggedIn;
            } else {
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

        backend.init().then(
          (value) {
            rotationLogoController.dispose();
            Navigator.push(
              context,
              MaterialPageRoute<bool>(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ); // initialize backend
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: () {
        if (loggedIn == loginStatus.loggedIn) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoogleUserCircleAvatar(
                    identity: currentUser!,
                  ),
                  Container(
                    width: 5,
                  ),
                  RotationTransition(turns: rotationAnimation, child: const DriveIcon()),
                ],
              ),
              const Text(
                "Syncing Google Drive",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
                ),
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
                    backgroundColor: Pallete.primary,
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
              const Text(
                "Sign In With Google",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 28,
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