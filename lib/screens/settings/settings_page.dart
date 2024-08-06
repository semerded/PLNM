import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/editors/category/category_editor_page.dart';
import 'package:keeper_of_projects/screens/settings/widgets/switch.dart';
import 'package:keeper_of_projects/screens/settings/widgets/switch_w_description.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void returnToPreviousPage() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, true);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.primary,
          title: const Text("Settings"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => returnToPreviousPage(),
          ),
        ),
        backgroundColor: Pallete.bg,
        body: Column(
          children: [
            SettingsSwitch(
              title: "DarkMode",
              initValue: settingsDataContent!["darkmode"],
              onChanged: (value) {
                setState(() {
                  settingsDataContent!["darkmode"] = value;
                  settingsDataNeedsSync = true;
                  Pallete.setDarkmode(value);
                });
              },
            ),
            SettingsSwitchWithDescription(
              title: "Show Project Size",
              description: "Shows the size of a project as a progress bar on the bottom of the project card.",
              initValue: settingsDataContent!["showProjectSize"],
              onChanged: (value) {
                setState(() {
                  settingsDataContent!["showProjectSize"] = value;
                  settingsDataNeedsSync = true;
                });
              },
            ),
            SettingsSwitchWithDescription(
              title: "Funny Project Sizes",
              description: "Add some funny project size descriptions into the mix, this changes the default {small, medium, big, ...} into something more... funny ;)",
              initValue: settingsDataContent!["funnyProjectSize"],
              onChanged: (value) {
                setState(() {
                  settingsDataContent!["funnyProjectSize"] = value;
                  settingsDataNeedsSync = true;
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Pallete.primary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<bool>(builder: (context) => const CategoryEditorPage()),
                ).then((value) async {
                  if (categoryDataNeedSync) {
                    await saveFile(categoryFileData!.id!, jsonEncode(categoryDataContent));
                  }
                });
              },
              child: const Text(
                "Edit Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
