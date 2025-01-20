// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/project_task/date_time_picker.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_category.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/common/widgets/loading_screen.dart';
import 'package:keeper_of_projects/mobile/pages/projects/part/add_project_part_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/part/edit_project_part_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_size_slider.dart';
import 'package:uuid/uuid.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final TextEditingController descriptionController = TextEditingController();

  Map newProject = {
    "title": "",
    "description": "",
    "category": [],
    "priority": "none",
    "size": 0.0,
    "part": [],
    "id": Uuid().v4(),
    "due": null,
  };

  bool isValid() {
    return newProject["title"].length >= 2 && newProject["part"].length >= 1;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await showConfirmDialog(context, "Cancel making this project")) {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          title: const Text("Create a new project"),
          backgroundColor: Palette.primary,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await showConfirmDialog(context, "Undo creating this project?")) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Column(
          children: [
            // add a title
            TitleTextField(
              hintText: "A unique title for your project",
              onChanged: (value) {
                setState(() {
                  newProject["title"] = value;
                });
              },
            ),

            // add a description
            DescriptionTextField(
              validTitle: newProject["title"].length >= 2,
              hintText: "Describe your project here",
              onChanged: (value) {
                setState(() {
                  newProject["description"] = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SelectCategory(
                    initChosenCategories: newProject["category"],
                    onChosen: (value) {
                      setState(() {
                        newProject["category"] = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SelectPriority(
                      initValue: projectPriorities.keys.first,
                      onUpdated: (value) {
                        setState(() {
                          print(value);
                          newProject["priority"] = value;
                        });
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    AdaptiveText("Size: ${() {
                      if (newProject["size"] == 0) {
                        return projectSizeDescription[0];
                      }
                      double value = ((newProject["size"] - 1) / projectSizeDescriptionSubdivisionNumber) + 1;
                      return projectSizeDescription[value.toInt()];
                    }()}"),
                    ProjectSizeSlider(
                      onChanged: (value) {
                        setState(() {
                          newProject["size"] = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
                DateTimePicker(
                  onDatePicked: (String? dateTime) {
                    newProject["due"] = dateTime;
                  },
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Map>(
                    builder: (context) => const AddProjectPartPage(),
                  ),
                ).then(
                  (value) {
                    if (value != null) {
                      print(value);
                      setState(() {
                        newProject["part"].add(value);
                      });
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.box3,
              ),
              label: AdaptiveText("Add Project Part"),
              icon: const Icon(
                Icons.add,
                color: Palette.primary,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: newProject["part"].length,
                itemBuilder: (context, index) {
                  Map part = newProject["part"][index];
                  return Card(
                    color: Palette.box3,
                    child: ListTile(
                      title: AdaptiveText(part["title"]),
                      subtitle: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Palette.subtext),
                          text: "${part["tasks"].length} • ",
                          children: [
                            TextSpan(
                              text: "${part["description"] != "" ? part["description"] : "no description"}",
                              style: TextStyle(
                                color: Palette.subtext,
                                fontStyle: part["description"] != "" ? FontStyle.normal : FontStyle.italic,
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
                                    builder: (context) => EditProjectPartPage(partData: newProject["part"][index]),
                                  ),
                                ).then((value) {
                                  if (value != null) {
                                    setState(() {
                                      newProject["part"][index] = value;
                                    });
                                  }
                                });
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              newProject["part"].removeAt(index);
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
              newProject["timeCreated"] = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString();
              newProject["size"] = newProject["size"].toInt();

              setState(() {
                projectsDataContent!["projects"].add(newProject); //! add deepcopy if duplication happens
                LoadingScreen.show(context, "Saving Task");
                fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent)).then((value) {
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
