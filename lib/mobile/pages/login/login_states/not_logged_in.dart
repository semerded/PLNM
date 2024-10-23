import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/common/icons/drive_icon.dart';
import 'package:keeper_of_projects/common/pages/about_page.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
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
        const Spacer(
          flex: 3,
        ),
        Image.asset(
          "assets/images/logo.png",
          width: 200,
        ),
        const SizedBox(
          height: 100,
        ),
        const Spacer(),
        const AdaptiveText(
          "Login To Continue",
          fontWeight: FontWeight.w800,
          fontSize: 28,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveIcon(
              Icons.devices,
              size: 40,
              color: Palette.primary,
            ),
            const SizedBox(
              width: 10,
            ),
            AdaptiveIcon(
              Icons.cloud_sync_sharp,
              size: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            const DriveIcon(),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  handleSignIn();
                },
                label: AdaptiveText("Login With Google"),
                icon: Image.asset(
                  "assets/images/google_logo.png",
                  width: 28,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: const BorderSide(color: Palette.primary),
                  ),
                ),
              ),
            ),
          ],
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
        const SizedBox(
          height: 50,
        )
      ],
    );
  }
}
