import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/project_task/date_time_picker.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/add_task.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/edit_task.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

class AddProjectPartPage extends StatefulWidget {
  const AddProjectPartPage({super.key});

  @override
  State<AddProjectPartPage> createState() => _AddProjectPartPageState();
}

class _AddProjectPartPageState extends State<AddProjectPartPage> {
  bool taskValidated = false;
  bool validTitle = false;
  final TextEditingController descriptionController = TextEditingController();

  Map newPart = {
    "title": null,
    "description": "",
    "priority": "none",
    "tasks": [],
    "completed": false,
    "due": null,
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(null);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          title: const Text("Add a new part for your project"),
          backgroundColor: Palette.primary,
        ),
        body: Column(
          children: [
            // add a title
            TitleTextField(
              hintText: "A unique title for your project part",
              onChanged: (value) {
                setState(() {
                  validTitle = value.length >= 2;
                  newPart["title"] = value;
                });
              },
            ),

            // add a description
            DescriptionTextField(
              validTitle: validTitle,
              hintText: "Describe your project part here",
              onChanged: (value) {
                setState(() {
                  newPart["description"] = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SelectPriority(
                      initValue: projectPriorities.keys.first,
                      onUpdated: (value) {
                        setState(() {
                          newPart["priority"] = value;
                        });
                      }),
                ),
                Expanded(
                  child: DateTimePicker(
                    onDatePicked: (String? dateTime) {
                      newPart["due"] = dateTime;
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                addTask(context).then(
                  (value) {
                    if (value != null) {
                      setState(() {
                        newPart["tasks"].add(value);
                      });
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.box3,
              ),
              label: AdaptiveText("Add Task"),
              icon: const Icon(
                Icons.add,
                color: Palette.primary,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: newPart["tasks"].length,
                itemBuilder: (context, index) {
                  Map task = newPart["tasks"][index];
                  return Card(
                    color: Palette.box3,
                    child: ListTile(
                      title: AdaptiveText(task["title"]),
                      subtitle: AdaptiveText(task["description"]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              editTask(context, task).then((editedTask) {
                                if (!const DeepCollectionEquality().equals(task, editedTask)) {
                                  setState(() {
                                    if (editedTask != null) {
                                      newPart["tasks"][index] = Map.from(editedTask);
                                    }
                                  });
                                }
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                newPart["tasks"].removeAt(index);
                              });
                            },
                            icon: AdaptiveIcon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: validTitle ? Colors.green : Colors.red,
          onPressed: () {
            if (validTitle) {
              Navigator.pop(context, newPart);
            }
          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
