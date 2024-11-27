import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/custom/progress_elevated_button.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/task_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/project_task/view_due_date.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/edit_project_part_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_button_info_dialog.dart';

// ignore: must_be_immutable
class ProjectPartViewPage extends StatefulWidget {
  Map part;
  final int index;
  final Map projectData;
  ProjectPartViewPage({
    super.key,
    required this.part,
    required this.index,
    required this.projectData,
  });

  @override
  State<ProjectPartViewPage> createState() => _ProjectPartViewPageState();
}

class _ProjectPartViewPageState extends State<ProjectPartViewPage> {
  bool setStateOnPagePop = false;
  late double partCompletion = calculateCompletion(widget.part["tasks"]);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, setStateOnPagePop);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          title: Text(widget.part["title"]),
          actions: [
            TaskPopUpMenu(
              enabledTasks: (() {
                List<TaskOptions> enabledTasks = [TaskOptions.delete, TaskOptions.edit];
                if (widget.part["tasks"].length != 0) {
                  enabledTasks.add(TaskOptions.completeAll);
                }
                return enabledTasks;
              }()),
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Map>(
                    builder: (context) => EditProjectPartPage(
                      partData: widget.part,
                      editingFromProjectPart: true,
                    ),
                  ),
                ).then((callback) async {
                  if (callback != null) {
                    setState(() {
                      widget.projectData["part"][widget.index] = Map.from(callback);
                      widget.part = Map.from(callback);
                      partCompletion = calculateCompletion(widget.part["tasks"]);

                      fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                      setStateOnPagePop = true;
                    });
                  }
                });
              },
              onCompleteAll: () {
                setState(() {
                  bool setValue = partCompletion != 1.0;
                  for (Map tasks in widget.part["tasks"]) {
                    tasks["completed"] = setValue;
                  }

                  partCompletion = calculateCompletion(widget.part["tasks"]);

                  fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                  setStateOnPagePop = true;
                });
              },
              onDelete: () {
                showConfirmDialog(context, 'Delete "${widget.part["title"]}" permanently? This can\'t be undone!').then((value) {
                  if (value) {
                    setState(() {
                      widget.projectData["part"].removeAt(widget.index);
                    });
                    fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                    setStateOnPagePop = true;
                    Navigator.pop(context, setStateOnPagePop);
                  }
                });
              },
              completeAllState: partCompletion == 1.0,
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              children: [
                //^ priority visualization
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        showInfoDialog(
                          context,
                          "Part priority: parts have different priorities. A part has a general priority while its part parts can have different priorities that are not linked to the general priority.",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: projectPriorities[widget.part["priority"]],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Palette.text),
                        ),
                      ),
                      child: Text(
                        "priority: ${widget.part["priority"]}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                //^ completion visualization
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.part["tasks"].length == 0
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                widget.part["completed"] = !widget.part["completed"];
                                setStateOnPagePop = true;
                                fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.part["completed"] ? Colors.green : Palette.bg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Palette.text),
                              ),
                            ),
                            child: AdaptiveText("complete${widget.part["completed"] ? "d" : ""}"),
                          )
                        : ProgressElevatedButton(
                            onPressed: () {
                              showInfoDialog(
                                context,
                                "Part completion, This shows how much of the part parts have been completed.",
                              );
                            },
                            progress: partCompletion,
                            progressColor: Colors.green,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.bg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Palette.text),
                              ),
                            ),
                            child: AdaptiveText("Progress: ${(partCompletion * 100).toInt()}"),
                          ),
                  ),
                )
              ],
            ),
            ViewDueDate(data: widget.part),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AdaptiveText(
                widget.part["description"] == "" ? "No Description" : widget.part["description"],
                fontStyle: widget.part["description"] == "" ? FontStyle.italic : null,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.part["tasks"].length,
                itemBuilder: (context, index) {
                  Map task = widget.part["tasks"][index];
                  return Card(
                    color: Palette.box3,
                    child: ListTile(
                      title: AdaptiveText(task["title"]),
                      subtitle: AdaptiveText(task["description"]),
                      shape: Border(
                        left: BorderSide(
                          width: 10,
                          color: projectPriorities[task["priority"]],
                        ),
                      ),
                      trailing: IconButton(
                        icon: AdaptiveIcon(
                          task["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            task["completed"] = !task["completed"];
                            partCompletion = calculateCompletion(widget.part["tasks"]);

                            fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                            setStateOnPagePop = true;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
