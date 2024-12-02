import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/task_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/task_vis_completion.dart';
import 'package:keeper_of_projects/common/widgets/project_task/view_due_date.dart';
import 'package:keeper_of_projects/common/widgets/project_task/vis_category.dart';
import 'package:keeper_of_projects/common/widgets/project_task/vis_priority.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/tasks/edit_task_page.dart';

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
                          children: [
                            VisPriority(data: widget.taskData),
                            VisCategory(
                                data: widget.taskData,
                                onUpdated: () => setState(() {
                                      setStateOnPagePop = true;
                                    })),
                          ],
                        ),
                        Row(
                          children: [
                            TaskVisCompletion(
                              data: widget.taskData,
                              taskCompletion: taskCompletion,
                              subTaskLength: widget.taskData["subTask"].length,
                              onUpdated: () => setState(() {
                                widget.taskData["completed"] = !widget.taskData["completed"];
                                fileSyncSystem.syncFile(taskFileData!, jsonEncode(taskDataContent));
                                setStateOnPagePop = true;
                              }),
                            )
                          ],
                        ),
                        ViewDueDate(data: widget.taskData),
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
                    color: Palette.box3,
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
                        icon: AdaptiveIcon(
                          subTask["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
                          size: 36,
                        ),
                        onPressed: () {
                          setState(() {
                            subTask["completed"] = !subTask["completed"];
                            taskCompletion = calculateCompletion(widget.taskData["subTask"]);

                            fileSyncSystem.syncFile(taskFileData!, jsonEncode(taskDataContent));
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
