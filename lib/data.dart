import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:intl/intl.dart';

import 'package:universal_platform/universal_platform.dart';

final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    drive.DriveApi.driveFileScope,
  ],
);

dynamic currentUser;
DateFormat dueDateFormater = DateFormat('dd-MM-yy HH:mm');
Timer? everySecondUpdate; //#001

const double bigProjectThreshold = 750.0;
const double bigProjectPartThreshold = 1100;
// ignore: non_constant_identifier_names
int activeProject_BigProjectView = 0;

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
  "Afternoon Doing", // small
  "Sunny Day job", // small medium
  "Weekend Done", // medium
  "Workweek (payed)", // medium big
  "There Goes My Holidays", // big
  "Months & months of work", // huge
  "Multiple Calenders", // year-plan
  "The Great Wall of China", // enormous
];
const double projectSizeDescriptionSubdivisionNumber = 99 / 8;

int activePage = (UniversalPlatform.isMobile) ? 2 : 0;

class Palette {
  static const MaterialColor primary = Colors.orange;
  static const MaterialColor secondary = Colors.lightGreen;
  static Color text = const Color.fromARGB(255, 30, 30, 30);
  static Color subtext = const Color.fromARGB(255, 90, 90, 90);
  static Color bg = Colors.white;
  static Color box1 = const Color.fromARGB(255, 223, 214, 214);
  static Color box2 = const Color.fromARGB(255, 201, 200, 200);
  static Color box3 = const Color.fromARGB(255, 199, 197, 197);
  static Color box4 = const Color.fromARGB(255, 167, 166, 166);

  static setDarkmode(bool status) {
    if (status) {
      Palette.text = Colors.white;
      Palette.bg = const Color.fromARGB(255, 30, 30, 30);
      Palette.subtext = const Color.fromARGB(255, 190, 190, 190);
      Palette.box1 = const Color.fromARGB(255, 48, 45, 45);
      Palette.box2 = const Color.fromARGB(255, 56, 53, 53);
      Palette.box3 = const Color.fromARGB(255, 66, 63, 63);
      Palette.box4 = const Color.fromARGB(255, 77, 73, 73);
    } else {
      Palette.text = const Color.fromARGB(255, 30, 30, 30);
      Palette.bg = Colors.white;
      Palette.subtext = const Color.fromARGB(255, 90, 90, 90);
      Palette.box1 = const Color.fromARGB(255, 223, 214, 214);
      Palette.box2 = const Color.fromARGB(255, 201, 200, 200);
      Palette.box3 = const Color.fromARGB(255, 199, 197, 197);
      Palette.box4 = const Color.fromARGB(255, 167, 166, 166);
    }
  }
}
