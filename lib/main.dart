import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/login/login_page.dart';
import 'package:keeper_of_projects/mobile/pages/login/login_page.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Palette.primary,
        ),
      ),
      home: Scaffold(
        body: () {
          if (Platform.isAndroid || Platform.isIOS || Platform.isFuchsia) {
            return const MobileLoginPage();
          }
          return const DesktopLoginPage();
        }(),
      ),
    );
  }
}
