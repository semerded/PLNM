import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    drive.DriveApi.driveFileScope,
  ],
);

dynamic currentUser;

const String projectCategoryUnknown = "Unknown Category";
bool projectCategoriesNeedRebuild = false;
Map<String, dynamic> projectPriorities = {
  "none": Colors.grey,
  "low": Colors.green,
  "medium": Colors.yellow,
  "high": Colors.red,
  "critical": Colors.purple,
};
List projectsContent = [];
List taskContent = [];
List ideasContent = [];

const List<String> projectSizeDescription = [
  "Unknown",
  "Very Small",
  "Small",
  "Small Medium",
  "Medium",
  "Medium Big",
  "Big",
  "Huge",
  "Year-Plan",
  "Enormous",
];
const List<String> projectSizeDescriptionAlternative = [
  "IDK (not really planned)", // unknown
  "Toilet Business", // very small
  "Afternooning Doing", // small
  "Sunny Day job", // small medium
  "Weekend Done", // medium
  "Workweek (payed)", // medium big
  "There Goes My Holidays", // big
  "Months & months of work", // huge
  "Multiple Calenders", // year-plan
  "The Great Wall of China", // enormous
];
const double projectSizeDescriptionSubdivisionNumber = 99 / 8;

int? activePage;

class Palette {
  static const MaterialColor primary = Colors.orange;
  static const MaterialColor secondary = Colors.lightGreen;
  static Color text = const Color.fromARGB(255, 30, 30, 30);
  static Color subtext = const Color.fromARGB(255, 90, 90, 90);
  static Color bg = Colors.white;
  static Color box = const Color.fromARGB(255, 210, 210, 210);
  static Color topbox = const Color.fromARGB(255, 230, 230, 230);

  static setDarkmode(bool status) {
    if (status) {
      Palette.text = Colors.white;
      Palette.bg = const Color.fromARGB(255, 30, 30, 30);
      Palette.box = const Color.fromARGB(255, 69, 69, 69);
      Palette.subtext = const Color.fromARGB(255, 190, 190, 190);
      Palette.topbox = const Color.fromARGB(255, 45, 45, 45);
    } else {
      Palette.text = const Color.fromARGB(255, 30, 30, 30);
      Palette.bg = Colors.white;
      Palette.box = const Color.fromARGB(255, 210, 210, 210);
      Palette.subtext = const Color.fromARGB(255, 90, 90, 90);
      Palette.topbox = const Color.fromARGB(255, 230, 230, 230);
    }
  }
}
