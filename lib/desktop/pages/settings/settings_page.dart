import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/settings/widgets/settings_content.dart';
import 'package:keeper_of_projects/desktop/widgets/empty_top_bar.dart';
import 'package:keeper_of_projects/desktop/widgets/navigation_rail.dart';
import 'package:keeper_of_projects/desktop/widgets/top_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                EmptyTopBar(
                  title: "Settings",
                  leading: IconButton(
                    icon: AdaptiveIcon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
                Expanded(
                    child: SettingsContent(
                  onUpdated: () => setState(() {}),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
