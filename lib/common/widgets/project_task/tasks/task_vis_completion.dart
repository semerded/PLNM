import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/custom/progress_elevated_button.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/common/widgets/project_task/info_dialog.dart';
import 'package:keeper_of_projects/typedef.dart';

class TaskVisCompletion extends StatefulWidget {
  final Map data;
  final double taskCompletion;
  final OnUpdated onUpdated;
  final int subTaskLength;

  const TaskVisCompletion({
    super.key,
    required this.data,
    required this.taskCompletion,
    required this.subTaskLength,
    required this.onUpdated,
  });

  @override
  State<TaskVisCompletion> createState() => _TaskVisCompletionState();
}

class _TaskVisCompletionState extends State<TaskVisCompletion> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.subTaskLength == 0
            ? ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.onUpdated();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.data["completed"] ? Colors.green : Palette.bg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Palette.text),
                  ),
                ),
                child: AdaptiveText("complete${widget.data["completed"] ? "d" : ""}"),
              )
            : ProgressElevatedButton(
                onPressed: () {
                  showInfoDialog(
                    context,
                    "Project completion, This shows how much of the project tasks have been completed.",
                  );
                },
                progress: widget.taskCompletion,
                progressColor: Colors.green,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.bg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Palette.text),
                  ),
                ),
                child: AdaptiveText("completion: ${(widget.taskCompletion * 100).toInt()}"),
              ),
      ),
    );
  }
}
