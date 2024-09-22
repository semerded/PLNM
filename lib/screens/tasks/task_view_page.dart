import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/custom/progress_elevated_button.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/check_category_validity.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/tasks/task_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/projects/widgets/project_button_info_dialog.dart';
import 'package:keeper_of_projects/screens/tasks/edit_task_page.dart';

class TaskViewPage extends StatefulWidget {
  Map taskData;
  final int index;
  TaskViewPage({required this.taskData, required this.index, super.key});

  @override
  State<TaskViewPage> createState() => _TaskViewPageState();
}

class _TaskViewPageState extends State<TaskViewPage> {
  late double taskCompletion = calculateCompletion(widget.taskData["subTask"]);
  bool projectDetailsVisible = true;
  bool setStateOnPagePop = false;

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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, setStateOnPagePop),
          ),
          title: Text(widget.taskData["title"]),
          actions: [
            TaskPopUpMenu(
              enabledTasks: const [TaskOptions.archive, TaskOptions.completeAll, TaskOptions.delete, TaskOptions.edit],
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Map>(
                    builder: (context) => EditTaskPage(
                      taskData: widget.taskData,
                    ),
                  ),
                ).then((callback) async {
                  if (callback != null) {
                    setState(() {
                      taskContent[widget.index] = Map.from(callback);
                      widget.taskData = Map.from(callback);
                      taskCompletion = calculateCompletion(widget.taskData["subTask"]);
                      setStateOnPagePop = true;
                    });
                    await fileSyncSystem.syncFile(taskFileData!, jsonEncode(taskDataContent));
                  }
                });
              },
              onArchive: () {},
              onCompleteAll: () {
                setState(() {
                  bool setValue = taskCompletion != 1.0;
                  for (Map subTask in widget.taskData["subTask"]) {
                    subTask["completed"] = setValue;
                  }
                  taskCompletion = calculateCompletion(widget.taskData["subTask"]);
                });
                fileSyncSystem.syncFile(taskFileData!, jsonEncode(taskDataContent));
                setStateOnPagePop = true;
              },
              onDelete: () {
                showConfirmDialog(context, 'Delete "${widget.taskData["title"]}" permanently? This can\'t be undone!').then((value) {
                  if (value) {
                    setState(() {
                      taskContent.removeAt(widget.index);
                    });
                    fileSyncSystem.syncFile(taskFileData!, jsonEncode(taskDataContent));
                    setStateOnPagePop = true;
                    Navigator.pop(context, setStateOnPagePop);
                  }
                });
              },
              completeAllState: taskCompletion == 1.0,
              archiveState: false,
            ),
          ],
        ),
        body: Column(
          children: [
            AnimatedSize(
              duration: Duration(milliseconds: 500),
              child: projectDetailsVisible
                  ? Column(
                      children: [
                        Row(
                          //^ priority visualtisation
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    showInfoDialog(
                                      context,
                                      "Task Prioirty: tasks have different priorities. A task has a general priority while its project tasks can have different priorities that are not linked to the general priority.",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: projectPriorities[widget.taskData["priority"]]),
                                  child: Text(
                                    "priority: ${widget.taskData["priority"]}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            //^ category visualisation
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: checkCategoryValidity(widget.taskData["category"])
                                    ? ElevatedButton(
                                        onPressed: () {
                                          showInfoDialog(
                                            context,
                                            "Project Category: The set category for this project. Categories are filterable in the project menu and tell more about a specific project.",
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Palette.bg,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Palette.text),
                                          ),
                                        ),
                                        child: AdaptiveText("category: ${widget.taskData["category"]}"),
                                      )
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Palette.text),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (await showConfirmDialog(context, "Add '${widget.taskData["category"]}' to categories?")) {
                                            setState(() {
                                              String category = widget.taskData["category"];
                                              categoryDataContent!.add(category);
                                              categoryFilter[category] = true;
                                              categoryDataNeedSync = true;
                                              fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
                                              setStateOnPagePop = true;
                                            });
                                          }
                                        },
                                        child: AdaptiveText("Unknown Category: ${widget.taskData["category"]}"),
                                      ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            //^ completion visualisation
                            Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: () {
                                    return ProgressElevatedButton(
                                      onPressed: () {
                                        showInfoDialog(
                                          context,
                                          "Project completion, This shows how much of the project tasks have been completed.",
                                        );
                                      },
                                      progress: taskCompletion,
                                      progressColor: Colors.green,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Palette.bg,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Palette.text),
                                        ),
                                      ),
                                      child: AdaptiveText("completion: ${(taskCompletion * 100).toInt()}"),
                                    );
                                  }()),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdaptiveText(
                            widget.taskData["description"] == "" ? "No Description" : widget.taskData["description"],
                            fontStyle: widget.taskData["description"] == "" ? FontStyle.italic : null,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.taskData["subTask"].length,
                itemBuilder: (context, index) {
                  Map subTask = widget.taskData["subTask"][index];
                  return Card(
                    color: Palette.topbox,
                    child: ListTile(
                      title: AdaptiveText(subTask["title"]),
                      subtitle: AdaptiveText(subTask["description"]),
                      shape: Border(
                        left: BorderSide(
                          width: 10,
                          color: projectPriorities[subTask["priority"]],
                        ),
                      ),
                      trailing: IconButton(
                        icon: AdaptiveIcon(subTask["completed"] ? Icons.check_box : Icons.check_box_outline_blank),
                        onPressed: () {
                          setState(() {
                            subTask["completed"] = !subTask["completed"];
                            taskCompletion = calculateCompletion(widget.taskData["subTask"]);

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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Palette.primary,
          mini: true,
          onPressed: () {
            setState(() {
              projectDetailsVisible = !projectDetailsVisible;
            });
          },
          child: const Icon(Icons.arrow_drop_up_outlined),
        ),
      ),
    );
  }
}
