import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/screens/about_page.dart';
import 'package:keeper_of_projects/screens/login_page.dart';
import 'package:keeper_of_projects/screens/settings/settings_page.dart';

// ignore: camel_case_types
enum _googleMenu { name, archive, settings, about, logout }

class GooglePopUpMenu extends StatefulWidget {
  final bool showArchive;
  final Widget? archiveRoute;
  GooglePopUpMenu({
    super.key,
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
      // popUpAnimationStyle: AnimationStyle(),
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
            MaterialPageRoute<bool>(builder: (context) => const LoginPage()),
          );
        } else if (item == _googleMenu.settings) {
          Navigator.push(
            context,
            MaterialPageRoute<bool>(builder: (context) => const SettingsPage()),
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
            leading: const Icon(Icons.settings),
            title: AdaptiveText('Settings'),
          ),
        ),
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.archive,
          child: ListTile(
            leading: const Icon(Icons.archive),
            title: AdaptiveText('Archive'),
          ),
        ),
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.about,
          child: ListTile(
            leading: const Icon(Icons.info_outline),
            title: AdaptiveText('About'),
          ),
        ),
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.logout,
          child: ListTile(
            leading: const Icon(Icons.logout),
            title: AdaptiveText('Logout'),
          ),
        ),
      ],
    );
  }
}
