import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
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
                      onChanged: (value) {
                        setState(
                          () {
                            newTask["description"] = value;
                          },
                        );
                      },
                      helperText: validTitle && descriptionController.text.isEmpty ? "Try to add a description" : null,
                      controller: descriptionController,
                      hintText: "Add a description for your task",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        color: Palette.box,
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          elevation: 15,
                          isExpanded: true,
                          dropdownColor: Palette.topbox,
                          value: ddb_priority_value,
                          items: projectPriorities.keys.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Row(
                                children: [
                                  Container(width: 30, height: 30, decoration: BoxDecoration(color: projectPriorities[value], shape: BoxShape.circle)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: AdaptiveText(
                                      value,
                                      overflow: TextOverflow.fade,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              newTask["priority"] = ddb_priority_value = value!;
                            });
                          },
                        ),
                      ),
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
