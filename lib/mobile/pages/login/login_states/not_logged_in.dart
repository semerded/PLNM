import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/common/icons/drive_icon.dart';
import 'package:keeper_of_projects/common/pages/about_page.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/switch_dark_mode_icon_button.dart';
import 'package:keeper_of_projects/data.dart';

class NotLoggedIn extends StatefulWidget {
  final VoidCallback callback;
  const NotLoggedIn({super.key, required this.callback});

  @override
  State<NotLoggedIn> createState() => _NotLoggedInState();
}

class _NotLoggedInState extends State<NotLoggedIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.bg,
        actions: [SwitchDarkModeIconButton(onSwitch: () => setState(() {}))],
      ),
      backgroundColor: Palette.bg,
      body: Column(
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
          AdaptiveText(
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
                  label: const Text(
                    "Login With Google",
                    style: TextStyle(color: Colors.black),
                  ),
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
                builder: (context) => AboutPage(
                  loggedIn: false,
                  callback: () => setState(() {}),
                ),
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
      ),
    );
  }
}
