import 'package:deepcopy/deepcopy.dart';
import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

Future editTask(BuildContext context, Map initTask) {
  Map editedTask = Map.from(initTask.deepcopy());

  bool validTitle = initTask.length >= 2;

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
                      initialValue: editedTask["description"],
                      onChanged: (value) {
                        setState(
                          () {
                            editedTask["description"] = value;
                          },
                        );
                      },
                      helperText: validTitle && descriptionController.text.isEmpty ? "Try to add a description" : null,
                      controller: descriptionController,
                      hintText: "Add a description for your task",
                    ),
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
