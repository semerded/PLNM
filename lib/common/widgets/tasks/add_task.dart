import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

Future addTask(BuildContext context) {
  Map<String, dynamic> newTask = {
    "title": "",
    "description": "",
    "priority": "none",
    "completed": false,
  };

  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController descriptionController = TextEditingController();
  return showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: AdaptiveText("add a subtask"),
          backgroundColor: Pallete.bg,
          content: Stack(
            children: [
              Form(
                child: Column(
                  children: [
                    TitleTextField(
                      focusNode: titleFocusNode,
                      onChanged: (value) {
                        setState(
                          () {
                            newTask["title"] = value;
                          },
                        );
                      },
                      hintText: "Add a description for your task",
                    ),
                    DescriptionTextField(
                      focusNode: descriptionFocusNode,
                      onChanged: (value) {
                        setState(
                          () {
                            newTask["description"] = value;
                          },
                        );
                      },
                      controller: descriptionController,
                      hintText: "Add a description for your task",
                    ),
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
