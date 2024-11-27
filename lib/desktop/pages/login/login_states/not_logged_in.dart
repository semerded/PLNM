import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/common/icons/drive_icon.dart';
import 'package:keeper_of_projects/common/pages/about_page.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

class NotLoggedIn extends StatefulWidget {
  const NotLoggedIn({super.key});

  @override
  State<NotLoggedIn> createState() => _NotLoggedInState();
}

class _NotLoggedInState extends State<NotLoggedIn> {
  @override
  Widget build(BuildContext context) {
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
  }
}
