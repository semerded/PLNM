import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/pages/about.dart';
import 'package:keeper_of_projects/pages/login.dart';
import 'package:keeper_of_projects/pages/settings.dart';

// ignore: camel_case_types
enum _googleMenu { name, settings, about, logout }

class GooglePopUpMenu extends StatefulWidget {
  const GooglePopUpMenu({super.key});

  @override
  State<GooglePopUpMenu> createState() => _GooglePopUpMenuState();
}

class _GooglePopUpMenuState extends State<GooglePopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_googleMenu>(
      // popUpAnimationStyle: AnimationStyle(),
      icon: GoogleUserCircleAvatar(
        identity: currentUser!,
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
        }
        else {
          
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_googleMenu>>[
        PopupMenuItem<_googleMenu>(
          value: _googleMenu.name,
          child: ListTile(
            leading: GoogleUserCircleAvatar(
              identity: currentUser!,
            ),
            title: Text(currentUser!.displayName ?? ''),
            subtitle: Text(currentUser!.email),
          ),
        ),
        const PopupMenuItem<_googleMenu>(
          value: _googleMenu.settings,
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ),
        const PopupMenuItem<_googleMenu>(
          value: _googleMenu.about,
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
          ),
        ),
        const PopupMenuItem<_googleMenu>(
          value: _googleMenu.logout,
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
      ],
    );
  }
}
