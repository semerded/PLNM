import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/tasks/add_task.dart';
import 'package:keeper_of_projects/common/widgets/tasks/edit_task.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:deepcopy/deepcopy.dart';

class EditTodoPage extends StatefulWidget {
  final Map todoData;
  const EditTodoPage({
    super.key,
    required this.todoData,
  });

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  Map updatedtodoData = {};
  late bool taskValidated;
  bool validTitle = false;
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    updatedtodoData = Map.from(widget.todoData.deepcopy());
    validTitle = updatedtodoData["title"].length >= 2;
    validate();
  }

  void validate() {
    taskValidated = validTitle && updatedtodoData["task"].length >= 1;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (await showConfirmDialog(context, "Undo changes made to this todo?")) {
          Navigator.pop(context, null);
        }
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          title: Text("Editing: ${widget.todoData["title"]}"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await showConfirmDialog(context, "Undo changes made to this todo?")) {
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
                  updatedtodoData["title"] = value;
                  validTitle = value.length >= 2;
                  validate();
                });
              },
              initialValue: updatedtodoData["title"],
            ),
            DescriptionTextField(
              validTitle: validTitle,
              onChanged: (value) {
                setState(() {
                  updatedtodoData["description"] = value;
                });
              },
              initialValue: updatedtodoData["description"],
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
                        value: updatedtodoData["category"], // check if exist
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
                            updatedtodoData["category"] = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SelectPriority(
                      value: updatedtodoData["priority"],
                      onUpdated: (value) {
                        setState(() {
                          updatedtodoData["priority"] = value;
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
                        updatedtodoData["task"].add(newTask);
                      });
                      validate();
                    }
                  },
                );
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
                itemCount: updatedtodoData["task"].length,
                itemBuilder: (context, index) {
                  Map task = updatedtodoData["task"][index];
                  return Card(
                    color: Palette.topbox,
                    child: ListTile(
                      title: AdaptiveText(task["title"]),
                      subtitle: Text(
                        task["description"],
                        style: TextStyle(color: Palette.subtext),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              editTask(context, updatedtodoData).then((editedTask) {
                                if (!const DeepCollectionEquality().equals(task, editedTask)) {
                                  setState(() {
                                    updatedtodoData["task"][index] = Map.from(editedTask);
                                  });
                                }
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showConfirmDialog(context, 'Delete "${task["title"]}" permanently? This can\'t be undone!').then((value) {
                                setState(() {
                                  if (value) {
                                    updatedtodoData["task"].removeAt(index);
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
              updatedtodoData["size"] = updatedtodoData["size"].toInt();
              Navigator.pop(context, updatedtodoData);
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
