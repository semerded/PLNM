import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/login/login_page.dart';
import 'package:keeper_of_projects/mobile/pages/login/login_page.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      scaffoldMessengerKey: scaffoldMessengerKey,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Palette.primary,
        ),
      ),
      home: Scaffold(
        body: () {
          if (UniversalPlatform.isMobile) {
            return const MobileLoginPage();
          } else {
            return const DesktopLoginPage();
          }
        }(),
      ),
    );
  }
}
