// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/date_time_picker.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_category.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/add_task.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/common/widgets/loading_screen.dart';
import 'package:keeper_of_projects/mobile/pages/projects/part/edit_project_part_page.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController descriptionController = TextEditingController();
  late String ddb_category_value;

  Map newTask = {
    "title": "",
    "description": "",
    "category": [],
    "priority": "none",
    "size": 0.0,
    "subTask": [],
    "completed": false,
    "due": null,
    "id": Uuid().v4(),
  };

  bool isValid() {
    return newTask["title"].length >= 2;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await showConfirmDialog(context, "Cancel making this task")) {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          title: const Text("Create a new task"),
          backgroundColor: Palette.primary,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await showConfirmDialog(context, "Undo creating this task?")) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Column(
          children: [
            // add a title
            TitleTextField(
              hintText: "What are you going to do?",
              onChanged: (value) {
                setState(() {
                  newTask["title"] = value;
                });
              },
            ),

            // add a description
            DescriptionTextField(
              validTitle: newTask["title"].length >= 2,
              hintText: "Describe the fine details",
              onChanged: (value) {
                setState(() {
                  newTask["description"] = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SelectCategory(
                    initChosenCategories: newTask["category"],
                    onChosen: (value) {
                      setState(() {
                        newTask["category"] = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SelectPriority(
                      initValue: projectPriorities.keys.first,
                      onUpdated: (value) {
                        setState(() {
                          newTask["priority"] = value;
                        });
                      }),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DateTimePicker(
                    onDatePicked: (String? dateTime) {
                      newTask["due"] = dateTime;
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Map newTask = await addTask(context);
                      setState(() {
                        newTask["subTask"].add(newTask);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.box3,
                    ),
                    label: AdaptiveText("Add A Sub Task"),
                    icon: const Icon(
                      Icons.add,
                      color: Palette.primary,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: newTask["subTask"].length,
                itemBuilder: (context, index) {
                  Map subTask = newTask["subTask"][index];
                  return Card(
                    color: Palette.box3,
                    child: ListTile(
                      title: AdaptiveText(subTask["title"]),
                      subtitle: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Palette.subtext),
                          text: "${subTask["subTask"].length} • ",
                          children: [
                            TextSpan(
                              text: "${subTask["description"] != "" ? subTask["description"] : "no description"}",
                              style: TextStyle(
                                color: Palette.subtext,
                                fontStyle: subTask["description"] != "" ? FontStyle.normal : FontStyle.italic,
                              ),
                            )
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<Map>(
                                    builder: (context) => EditProjectPartPage(partData: newTask["subTask"][index]), // TODO check this
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      newTask["subTask"][index] = value;
                                    });
                                  }
                                });
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              newTask["subTask"].removeAt(index);
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
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
          onPressed: () {
            if (isValid()) {
              DateTime now = DateTime.now();
              newTask["timeCreated"] = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString();
              newTask["size"] = newTask["size"].toInt();

              setState(() {
                taskDataContent!["task"].add(newTask); //! add deepcopy if duplication happens
                LoadingScreen.show(context, "Saving Task");
                fileSyncSystem.syncFile(taskFileData!, jsonEncode(taskDataContent)).then((value) {
                  LoadingScreen.hide(context);
                  Navigator.of(context).pop(true);
                });
              });
            }
          },
          backgroundColor: isValid() ? Colors.green : Colors.red,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
