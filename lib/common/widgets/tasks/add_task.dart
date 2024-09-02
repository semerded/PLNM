import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

Future addTask(BuildContext context) {
  Map newTask = {
    "title": "",
    "description": "",
    "priority": "none",
    "completed": false,
  };

  String ddb_priority_value = projectPriorities.keys.first;

  bool validTitle = false;

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
                      onChanged: (value) {
                        setState(
                          () {
                            validTitle = value.length >= 2;
                            newTask["title"] = value;
                          },
                        );
                      },
                      hintText: "Add a title for your task",
                    ),
                    DescriptionTextField(
                      validTitle: validTitle,
                      onChanged: (value) {
                        setState(
                          () {
                            newTask["description"] = value;
                          },
                        );
                      },
                      hintText: "Add a description for your task",
                    ),
                    SelectPriority(
                        value: ddb_priority_value,
                        onUpdated: (value) {
                          setState(() {
                            newTask["priority"] = value;
                          });
                        }),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (newTask["title"] != "") {
                          setState(() {
                            Navigator.pop(context, newTask);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: newTask["title"] != "" ? Colors.green : Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      label: const Text("Add subtask"),
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
