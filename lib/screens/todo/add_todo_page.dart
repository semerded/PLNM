// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/tasks/add_task.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/common/widgets/loading_screen.dart';
import 'package:keeper_of_projects/screens/projects/add_project_part_page.dart';
import 'package:keeper_of_projects/screens/projects/edit_project_part_page.dart';
import 'package:keeper_of_projects/screens/projects/widgets/project_size_slider.dart';
import 'package:uuid/uuid.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  bool taskValidated = false;
  bool validTitle = false;
  bool validCategory = false;
  final TextEditingController descriptionController = TextEditingController();
  late String ddb_priority_value;
  late String ddb_category_value;

  Map newTodo = {
    "title": null,
    "description": "",
    "category": null,
    "priority": "none",
    "size": 0.0,
    "task": [],
    "id": Uuid().v4(),
  }; // TODO switch "none" to null

  final String ddb_catgegoryDefaultText = "Select A Category";
  List<String> ddb_category = [];

  void validate() {
    taskValidated = validTitle && validCategory;
  }

  @override
  void initState() {
    super.initState();
    ddb_priority_value = projectPriorities.keys.first;
    ddb_category_value = ddb_catgegoryDefaultText;

    ddb_category.add(ddb_catgegoryDefaultText);
    ddb_category.addAll(categoryDataContent!);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await showConfirmDialog(context, "Cancel making this todo")) {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          title: const Text("Create a new todo"),
          backgroundColor: Palette.primary,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await showConfirmDialog(context, "Undo creating this todo?")) {
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
                  validTitle = value.length >= 2;
                  newTodo["title"] = value;
                  validate();
                });
              },
            ),

            // add a description
            DescriptionTextField(
              validTitle: validTitle,
              hintText: "Describe the fine details",
              onChanged: (value) {
                setState(() {
                  newTodo["description"] = value;
                  validate();
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      color: Palette.box,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        isExpanded: true,
                        elevation: 15,
                        dropdownColor: Palette.topbox,
                        value: ddb_category_value,
                        items: ddb_category.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: AdaptiveText(
                                value,
                                overflow: TextOverflow.fade,
                                fontStyle: value == ddb_catgegoryDefaultText ? FontStyle.italic : FontStyle.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            newTodo["category"] = ddb_category_value = value!;
                            validCategory = value != ddb_catgegoryDefaultText;
                            validate();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SelectPriority(
                      value: ddb_priority_value,
                      onUpdated: (value) {
                        setState(() {
                          print(value);
                          newTodo["priority"] = value;
                          validate();
                        });
                      }),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Map newTask = await addTask(context);
                setState(() {
                  newTodo["task"].add(newTask);
                  validate();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.topbox,
              ),
              label: AdaptiveText("Add A Task"),
              icon: const Icon(
                Icons.add,
                color: Palette.primary,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: newTodo["task"].length,
                itemBuilder: (context, index) {
                  Map task = newTodo["task"][index];
                  return Card(
                    color: Palette.topbox,
                    child: ListTile(
                      title: AdaptiveText(task["title"]),
                      subtitle: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Palette.subtext),
                          text: "${task["tasks"].length} • ",
                          children: [
                            TextSpan(
                              text: "${task["description"] != "" ? task["description"] : "no description"}",
                              style: TextStyle(
                                color: Palette.subtext,
                                fontStyle: task["description"] != "" ? FontStyle.normal : FontStyle.italic,
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
                                    builder: (context) => EditProjectPartPage(partData: newTodo["task"][index]),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      newTodo["task"][index] = value;
                                    });
                                  }
                                });
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              newTodo["task"].removeAt(index);
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
            if (taskValidated) {
              DateTime now = DateTime.now();
              newTodo["timeCreated"] = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString();
              newTodo["size"] = newTodo["size"].toInt();

              setState(() {
                todoDataContent!["todo"].add(newTodo); //! add deepcopy if duplication happens
                LoadingScreen.show(context, "Saving Todo");
                fileSyncSystem.syncFile(todoFileData!, jsonEncode(todoDataContent)).then((value) {
                  LoadingScreen.hide(context);
                  Navigator.of(context).pop(true);
                });
              });
            }
          },
          backgroundColor: taskValidated ? Colors.green : Colors.red,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
