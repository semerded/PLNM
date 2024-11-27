import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/pages/about_page.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/mobile/pages/login/login_page.dart';
import 'package:keeper_of_projects/mobile/pages/profile_page.dart';
import 'package:keeper_of_projects/mobile/pages/settings/settings_page.dart';

// ignore: camel_case_types
enum _googleMenu { name, archive, settings, about, logout }

typedef OnClose = void Function(bool value);

class GooglePopUpMenu extends StatefulWidget {
  final bool showArchive;
  final OnClose onClose;
  final Widget? archiveRoute;
  GooglePopUpMenu({
    super.key,
    required this.onClose,
    this.showArchive = false,
    this.archiveRoute,
  }) {
    if (showArchive) {
      archiveRoute!;
    }
  }

  @override
  State<GooglePopUpMenu> createState() => _GooglePopUpMenuState();
}

class _GooglePopUpMenuState extends State<GooglePopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_googleMenu>(
      color: Palette.box3,
      popUpAnimationStyle: AnimationStyle(),
      icon: Hero(
        tag: "googleUserCircleAvatar",
        child: GoogleUserCircleAvatar(
          identity: currentUser!,
        ),
      ),
      onSelected: (_googleMenu item) {
        if (item == _googleMenu.logout) {
          handleSignOut();
          Navigator.push(
            context,
            MaterialPageRoute<bool>(builder: (context) => const MobileLoginPage()),
          );
        } else if (item == _googleMenu.settings) {
          Navigator.push(
            context,
            MaterialPageRoute<bool>(builder: (context) => const SettingsPage()),
          ).then(
            (value) async {
              if (value != null && value) {
                setState(() {});
              }
              widget.onClose(true);
              if (settingsDataNeedsSync) {
                await fileSyncSystem.syncFile(settingsFileData!, jsonEncode(settingsDataContent)).then(
                  (_) {
                    settingsDataNeedsSync = false;
                  },
                );
              }
            },
          );
        } else if (item == _googleMenu.about) {
          Navigator.push(
            context,
            MaterialPageRoute<bool>(builder: (context) => const AboutPage()),
          );
        } else if (item == _googleMenu.archive && widget.showArchive) {
          Navigator.push(
            context,
            MaterialPageRoute<bool>(builder: (context) => widget.archiveRoute!),
          );
        } else if (item == _googleMenu.name) {
          Navigator.push(
            context,
            MaterialPageRoute<bool>(builder: (context) => const ProfilePage()),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_googleMenu>>[
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.name,
          child: ListTile(
            leading: GoogleUserCircleAvatar(
              identity: currentUser!,
            ),
            title: AdaptiveText(currentUser!.displayName ?? ''),
            subtitle: AdaptiveText(currentUser!.email),
          ),
        ),
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.settings,
          child: ListTile(
            leading: AdaptiveIcon(Icons.settings),
            title: AdaptiveText('Settings'),
          ),
        ),
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.archive,
          child: ListTile(
            leading: AdaptiveIcon(Icons.archive),
            title: AdaptiveText('Archive'),
          ),
        ),
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.about,
          child: ListTile(
            leading: AdaptiveIcon(Icons.info_outline),
            title: AdaptiveText('About'),
          ),
        ),
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.logout,
          child: ListTile(
            leading: AdaptiveIcon(Icons.logout),
            title: AdaptiveText('Logout'),
          ),
        ),
      ],
    );
  }
}
