import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    drive.DriveApi.driveFileScope,
  ],
);

GoogleSignInAccount? currentUser;


class Pallete {
  static const MaterialColor primary = Colors.orange;
  static const MaterialColor secondary = Colors.lightGreen;
  static Color text = const Color.fromARGB(255, 30, 30, 30);
  static Color bg = Colors.white;
  static Color box = const Color.fromARGB(255, 210, 210, 210);

  static setDarkmode(bool status) {
    if (status) {
      Pallete.text = Colors.white;
      Pallete.bg = const Color.fromARGB(255, 30, 30, 30);
      Pallete.box = const Color.fromARGB(255, 69, 69, 69);
    } else {
      Pallete.text = const Color.fromARGB(255, 30, 30, 30);
      Pallete.bg = Colors.white;
      Pallete.box = const Color.fromARGB(255, 210, 210, 210);
    }
  }
}