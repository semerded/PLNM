import 'package:collection/collection.dart';
import 'package:deepcopy/deepcopy.dart';
import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/project_task/date_time_picker.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/add_task.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/edit_task.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

class EditProjectPartPage extends StatefulWidget {
  final Map partData;
  final bool editingFromProjectPart;
  const EditProjectPartPage({
    super.key,
    required this.partData,
    this.editingFromProjectPart = false,
  });

  @override
  State<EditProjectPartPage> createState() => _EditProjectPartPageState();
}

class _EditProjectPartPageState extends State<EditProjectPartPage> {
  Map updatedPart = {};
  late bool validTitle;

  @override
  void initState() {
    super.initState();
    updatedPart = Map.from(widget.partData.deepcopy());
    validTitle = updatedPart["title"].length >= 2;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, null);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          leading: widget.editingFromProjectPart
              ? IconButton(
                  onPressed: () async {
                    if (await showConfirmDialog(context, "Undo changes made to this project?")) {
                      Navigator.pop(context, null);
                    }
                  },
                  icon: const Icon(Icons.close),
                )
              : null,
        ),
        body: Column(
          children: [
            TitleTextField(
              onChanged: (value) {
                setState(() {
                  validTitle = value.length >= 2;

                  updatedPart["title"] = value;
                });
              },
              initialValue: updatedPart["title"],
            ),
            DescriptionTextField(
              validTitle: validTitle,
              onChanged: (value) {
                setState(() {
                  updatedPart["description"] = value;
                });
              },
              initialValue: updatedPart["description"],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SelectPriority(
                      initValue: updatedPart["priority"],
                      onUpdated: (value) {
                        setState(() {
                          updatedPart["priority"] = value;
                        });
                      }),
                ),
                Expanded(
                  child: DateTimePicker(
                    defaultValue: widget.partData["due"] == null ? null : toMinuteFormatter.parse(widget.partData["due"]),
                    onDatePicked: (String? dateTime) {
                      updatedPart["due"] = dateTime;
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
                        updatedPart["tasks"].add(value);
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
                itemCount: updatedPart["tasks"].length,
                itemBuilder: (context, index) {
                  Map task = updatedPart["tasks"][index];
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
                                    updatedPart["tasks"][index] = Map.from(editedTask);
                                  });
                                }
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showConfirmDialog(context, 'Delete "${task["title"]}" permanently? This can\'t be undone!').then((value) {
                                if (value) {
                                  setState(() {
                                    updatedPart["tasks"].removeAt(index);
                                  });
                                }
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
          backgroundColor: validTitle ? Colors.green : Colors.red,
          onPressed: () {
            if (validTitle) {
              Navigator.pop(context, updatedPart);
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
