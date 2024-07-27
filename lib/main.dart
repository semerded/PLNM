import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/login_page.dart';

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
          cursorColor: Pallete.primary,
        ),
      ),
      home: const Scaffold(
        body: LoginPage(),
      ),
    );
  }
}
