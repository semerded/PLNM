import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/functions/deadline_checker.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/project_task/date_time_picker.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_category.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:deepcopy/deepcopy.dart';
import 'package:keeper_of_projects/mobile/pages/projects/part/add_project_part_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/part/edit_project_part_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_size_slider.dart';

class EditProjectPage extends StatefulWidget {
  final Map projectData;
  const EditProjectPage({
    super.key,
    required this.projectData,
  });

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  Map updatedProjectData = {};
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();

    updatedProjectData = Map.from(widget.projectData.deepcopy());
  }

  bool isValid() {
    return updatedProjectData["title"].length >= 2 && updatedProjectData["part"].length >= 1;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (await showConfirmDialog(context, "Undo changes made to this project?")) {
          Navigator.pop(context, null);
        }
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          title: Text("Editing: ${widget.projectData["title"]}"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await showConfirmDialog(context, "Undo changes made to this project?")) {
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
                  updatedProjectData["title"] = value;
                });
              },
              initialValue: updatedProjectData["title"],
            ),
            DescriptionTextField(
              validTitle: updatedProjectData["title"].length >= 2,
              onChanged: (value) {
                setState(() {
                  updatedProjectData["description"] = value;
                });
              },
              initialValue: updatedProjectData["description"],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SelectCategory(
                    initChosenCategories: updatedProjectData["category"],
                    onChosen: (value) {
                      setState(() {
                        updatedProjectData["category"] = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: SelectPriority(
                      initValue: updatedProjectData["priority"],
                      onUpdated: (value) {
                        setState(() {
                          updatedProjectData["priority"] = value;
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
                      if (updatedProjectData["size"] == 0) {
                        return projectSizeDescription[0];
                      }
                      double value = ((updatedProjectData["size"] - 1) / projectSizeDescriptionSubdivisionNumber) + 1;
                      return projectSizeDescription[value.toInt()];
                    }()}"),
                    ProjectSizeSlider(
                      initialValue: updatedProjectData["size"].toDouble(),
                      onChanged: (value) {
                        setState(() {
                          updatedProjectData["size"] = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
                DateTimePicker(
                  defaultValue: widget.projectData["due"] == null ? null : toMinuteFormatter.parse(widget.projectData["due"]),
                  onDatePicked: (String? dateTime) {
                    updatedProjectData["due"] = dateTime;
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
                        updatedProjectData["part"].add(value);
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
                itemCount: updatedProjectData["part"].length,
                itemBuilder: (context, index) {
                  Map part = updatedProjectData["part"][index];
                  return Card(
                    color: Palette.box3,
                    child: ListTile(
                      title: AdaptiveText(part["title"]),
                      subtitle: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Palette.subtext),
                          text: "${part["tasks"].length} • ",
                          children: [
                            if (part["due"] != null)
                              TextSpan(
                                text: "${deadlineChecker(toMinuteFormatter.parse(part["due"]))} • ",
                                style: TextStyle(
                                  color: overdue(toMinuteFormatter.parse(part["due"])) ? Colors.red : Palette.subtext,
                                ),
                              ),
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
                              Navigator.push(
                                context,
                                MaterialPageRoute<Map>(
                                  builder: (context) => EditProjectPartPage(
                                    partData: part,
                                  ),
                                ),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    updatedProjectData["part"][index] = value;
                                  });
                                }
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              showConfirmDialog(context, 'Delete "${part["title"]}" permanently? This can\'t be undone!').then((value) {
                                setState(() {
                                  if (value) {
                                    updatedProjectData["part"].removeAt(index);
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
          backgroundColor: isValid() ? Colors.green : Colors.red,
          onPressed: () {
            if (isValid()) {
              updatedProjectData["size"] = updatedProjectData["size"].toInt();
              Navigator.pop(context, updatedProjectData);
            }
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
