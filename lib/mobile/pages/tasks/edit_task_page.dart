import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/add_task.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/edit_task.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:deepcopy/deepcopy.dart';

class EditTaskPage extends StatefulWidget {
  final Map taskData;
  const EditTaskPage({
    super.key,
    required this.taskData,
  });

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  Map updatedtaskData = {};
  late bool taskValidated;
  bool validTitle = false;
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    updatedtaskData = Map.from(widget.taskData.deepcopy());
    validTitle = updatedtaskData["title"].length >= 2;
    validate();
  }

  void validate() {
    taskValidated = validTitle && updatedtaskData["subTask"].length >= 1;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (await showConfirmDialog(context, "Undo changes made to this task?")) {
          Navigator.pop(context, null);
        }
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          title: Text("Editing: ${widget.taskData["title"]}"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await showConfirmDialog(context, "Undo changes made to this task?")) {
                Navigator.pop(context, null);
              }
            },
          ),
        ),
        body: Column(
          children: [
            TitleTextField(
              onChanged: (value) {
                setState(() {
                  updatedtaskData["title"] = value;
                  validTitle = value.length >= 2;
                  validate();
                });
              },
              initialValue: updatedtaskData["title"],
            ),
            DescriptionTextField(
              validTitle: validTitle,
              onChanged: (value) {
                setState(() {
                  updatedtaskData["description"] = value;
                });
              },
              initialValue: updatedtaskData["description"],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      color: Palette.box1,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        isExpanded: true,
                        elevation: 15,
                        dropdownColor: Palette.box3,
                        value: updatedtaskData["category"], // check if exist
                        items: categoryDataContent?.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: AdaptiveText(
                                value,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            updatedtaskData["category"] = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SelectPriority(
                      value: updatedtaskData["priority"],
                      onUpdated: (value) {
                        setState(() {
                          updatedtaskData["priority"] = value;
                        });
                      }),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                addTask(context).then(
                  (newTask) {
                    if (newTask != null) {
                      setState(() {
                        updatedtaskData["subTask"].add(newTask);
                      });
                      validate();
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.box3,
              ),
              label: AdaptiveText("Add A Task"),
              icon: const Icon(
                Icons.add,
                color: Palette.primary,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: updatedtaskData["subTask"].length,
                itemBuilder: (context, index) {
                  Map subTask = updatedtaskData["subTask"][index];
                  return Card(
                    color: Palette.box3,
                    child: ListTile(
                      title: AdaptiveText(subTask["title"]),
                      subtitle: Text(
                        subTask["description"],
                        style: TextStyle(color: Palette.subtext),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              editTask(context, updatedtaskData["subTask"][index]).then((editedTask) {
                                if (editedTask != null && !const DeepCollectionEquality().equals(subTask, editedTask)) {
                                  setState(() {
                                    updatedtaskData["subTask"][index] = Map.from(editedTask);
                                  });
                                }
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showConfirmDialog(context, 'Delete "${subTask["title"]}" permanently? This can\'t be undone!').then((value) {
                                setState(() {
                                  if (value) {
                                    updatedtaskData["subTask"].removeAt(index);
                                    validate();
                                  }
                                });
                              });
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
          backgroundColor: taskValidated ? Colors.green : Colors.red,
          onPressed: () {
            if (taskValidated) {
              updatedtaskData["size"] = updatedtaskData["size"].toInt();
              Navigator.pop(context, updatedtaskData);
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
