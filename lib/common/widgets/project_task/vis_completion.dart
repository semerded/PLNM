import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/custom/progress_elevated_button.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_button_info_dialog.dart';

class VisCompletion extends StatelessWidget {
  final double projectCompletion;
  const VisCompletion({
    super.key,
    required this.projectCompletion,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: () {
            return ProgressElevatedButton(
              onPressed: () {
                showInfoDialog(
                  context,
                  "Project completion, This shows how much of the project parts have been completed.",
                );
              },
              progress: projectCompletion,
              progressColor: Colors.green,
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Palette.text),
                ),
              ),
              child: AdaptiveText("completion: ${(projectCompletion * 100).toInt()}"),
            );
          }()),
    );
  }
}
