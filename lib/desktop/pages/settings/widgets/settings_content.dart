import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/pages/category_editor/category_editor_page.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/settings/widgets/switch.dart';
import 'package:keeper_of_projects/desktop/pages/settings/widgets/switch_w_description.dart';
import 'package:keeper_of_projects/typedef.dart';

class SettingsContent extends StatefulWidget {
  final OnUpdated onUpdated;
  const SettingsContent({
    super.key,
    required this.onUpdated,
  });

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsSwitch(
          title: "DarkMode",
          initValue: settingsDataContent!["darkmode"],
          onChanged: (value) {
            setState(() {
              settingsDataContent!["darkmode"] = value;
              settingsDataNeedsSync = true;
              Palette.setDarkmode(value);
              widget.onUpdated();
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
          title: "Alt Project Size Description",
          description: "Add some funny project size descriptions into the mix, this changes the default {small, medium, big, ...} into something more... funny ;). (this doesn't show when you create a new project)",
          initValue: settingsDataContent!["funnyProjectSize"],
          onChanged: (value) {
            setState(() {
              settingsDataContent!["funnyProjectSize"] = value;
              settingsDataNeedsSync = true;
            });
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Palette.primary),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<bool>(builder: (context) => const CategoryEditorPage()),
            ).then((value) async {
              if (categoryDataNeedSync) {
                await fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
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
    );
  }
}
