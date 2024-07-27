import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/settings/widgets/switch.dart';

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
              switchTitle: "DarkMode",
              initValue: settingsDataContent!["darkmode"],
              onChanged: (value) {
                setState(() {
                  settingsDataContent!["darkmode"] = value;
                  settingsDataNeedsSync = true;
                  Pallete.setDarkmode(value);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
