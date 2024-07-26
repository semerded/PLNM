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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text("Settings"),
      ),
      backgroundColor: Pallete.bg,
      body: Column(
        children: [
          SettingsSwitch(
            switchTitle: "DarkMode",
            initValue: settingsDataContent!["darkmode"],
            onChanged: (value) {
              setState(() {
                Pallete.setDarkmode(value);
              });
            },
          )
        ],
      ),
    );
  }
}
