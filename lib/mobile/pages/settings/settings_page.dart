import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/local_file_handler.dart';
import 'package:keeper_of_projects/common/pages/category_editor/category_editor_page.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/card_group.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/settings/download_from_cloud.dart';
import 'package:keeper_of_projects/mobile/pages/settings/upload_to_cloud.dart';
import 'package:keeper_of_projects/mobile/pages/settings/widgets/cloud_actions.dart';
import 'package:keeper_of_projects/mobile/pages/settings/widgets/setting_switch.dart';
import 'package:keeper_of_projects/mobile/pages/settings/widgets/settings_icon_button.dart';

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
          backgroundColor: Palette.primary,
          title: const Text("Settings"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => returnToPreviousPage(),
          ),
        ),
        backgroundColor: Palette.bg,
        body: ListView(
          children: [
            CardGroup(title: "Appearance", children: [
              SettingsSwitch(
                title: "Enable Dark Mode",
                initValue: settingsDataContent!["darkmode"],
                onChanged: (value) {
                  setState(() {
                    settingsDataContent!["darkmode"] = value;
                    settingsDataNeedsSync = true;
                    Palette.setDarkmode(value);
                  });
                },
              ),
            ]),
            CardGroup(
              title: "idk",
              children: [
                SettingsSwitch(
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
              ],
            ),
            CardGroup(
              title: "Search and filter",
              children: [
                SettingsSwitch(
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
              ],
            ),
            CardGroup(
              title: "Cloud/local storage",
              children: [
                SettingsIconButton(
                  title: "Download from cloud",
                  onClicked: () {},
                  icon: AdaptiveIcon(Icons.download),
                ),
                SettingsIconButton(
                  title: "Upload to cloud",
                  onClicked: () {},
                  icon: AdaptiveIcon(Icons.upload),
                ),
                SettingsIconButton(
                  title: "Delete local data",
                  onClicked: () {
                    showConfirmDialog(context, "Are you sure you want to delete all local data?").then((confirm) async {
                      if (confirm) {
                        await deleteLocalFiles();
                        await onlyRepairLocalFiles();
                        if (kDebugMode) {
                          debugPrint("Deleted all local data");
                        }
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Palette.primary),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<bool>(builder: (context) => const CategoryEditorPage()),
                );
              },
              child: const Text(
                "Edit Categories",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                CloudActions(
                  route: DownloadFromCloud(),
                  label: "from cloud",
                  icon: Icons.download,
                  onUpdated: () => setState(() {}),
                ),
                CloudActions(
                  route: UploadToCloud(),
                  label: "to cloud",
                  icon: Icons.upload,
                  onUpdated: () => setState(() {}),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
