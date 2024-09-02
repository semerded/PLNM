import 'package:deepcopy/deepcopy.dart';
import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

Future editTask(BuildContext context, Map initTask) {
  Map editedTask = Map.from(initTask.deepcopy());

  bool validTitle = initTask.length >= 2;
  String ddb_priority_value = projectPriorities.keys.first;

  final TextEditingController descriptionController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: AdaptiveText("add a subtask"),
          backgroundColor: Palette.bg,
          content: Stack(
            children: [
              Form(
                child: Column(
                  children: [
                    TitleTextField(
                      initialValue: editedTask["title"],
                      onChanged: (value) {
                        setState(
                          () {
                            validTitle = value.length >= 2;
                            editedTask["title"] = value;
                          },
                        );
                      },
                      hintText: "Add a title for your task",
                    ),
                    DescriptionTextField(
                      validTitle: validTitle,
                      initialValue: editedTask["description"],
                      onChanged: (value) {
                        setState(
                          () {
                            editedTask["description"] = value;
                          },
                        );
                      },
                      hintText: "Add a description for your task",
                    ),
                    SelectPriority(
                        value: ddb_priority_value,
                        onUpdated: (value) {
                          setState(() {
                            editedTask["priority"] = value;
                          });
                        }),
                  ],
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: AdaptiveText("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (validTitle) {
                  Navigator.pop(context, editedTask);
                }
              },
              child: Text("Save", style: TextStyle(color: validTitle ? Palette.primary : Palette.subtext)),
            ),
          ],
        ),
      );
    },
  );
}
