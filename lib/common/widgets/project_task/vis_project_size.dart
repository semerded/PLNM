import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/custom/progress_elevated_button.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/common/widgets/project_task/info_dialog.dart';

class VisProjectSize extends StatelessWidget {
  final Map data;
  const VisProjectSize({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ProgressElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Palette.text),
            ),
          ),
          onPressed: () {
            showInfoDialog(
              context,
              "Project Size: Shows the size of the project, the description converts a percental scale to something more readable. The background shows the percental scale.",
            );
          },
          progress: () {
            int size = data["size"];
            return size.toDouble() / 100;
          }(),
          progressColor: Palette.primary,
          child: Text(
            () {
              List<String> currentProjectSizeDescription = settingsDataContent!["funnyProjectSize"] ? projectSizeDescriptionAlternative : projectSizeDescription;
              if (data["size"] == 0) {
                return currentProjectSizeDescription[0];
              }
              double value = ((data["size"] - 1) / projectSizeDescriptionSubdivisionNumber) + 1;
              return currentProjectSizeDescription[value.toInt()];
            }(),
            style: TextStyle(color: Palette.text),
          ),
        ),
      ),
    );
  }
}
