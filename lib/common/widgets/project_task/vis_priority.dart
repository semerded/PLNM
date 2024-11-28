import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_button_info_dialog.dart';

class VisPriority extends StatelessWidget {
  final Map data;
  const VisPriority({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: ElevatedButton(
          onPressed: () {
            showInfoDialog(
              context,
              "Project Prioirty: projects have different priorities. A project has a general priority while its project parts can have different priorities that are not linked to the general priority.",
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: projectPriorities[data["priority"]]),
          child: Text(
            "priority: ${data["priority"]}",
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
