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
import 'package:keeper_of_projects/screens/todo/edit_todo_page.dart';

class TodoViewPage extends StatefulWidget {
  Map todoData;
  final int index;
  TodoViewPage({required this.todoData, required this.index, super.key});

  @override
  State<TodoViewPage> createState() => _TodoViewPageState();
}

class _TodoViewPageState extends State<TodoViewPage> {
  late double todoCompletion = calculateCompletion(widget.todoData["task"]);
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
          title: Text(widget.todoData["title"]),
          actions: [
            TaskPopUpMenu(
              enabledTasks: const [TaskOptions.archive, TaskOptions.completeAll, TaskOptions.delete, TaskOptions.edit],
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Map>(
                    builder: (context) => EditTodoPage(
                      todoData: widget.todoData,
                    ),
                  ),
                ).then((callback) async {
                  if (callback != null) {
                    setState(() {
                      todoContent[widget.index] = Map.from(callback);
                      widget.todoData = Map.from(callback);
                      todoCompletion = calculateCompletion(widget.todoData["task"]);
                      setStateOnPagePop = true;
                    });
                    await fileSyncSystem.syncFile(todoFileData!, jsonEncode(todoDataContent));
                  }
                });
              },
              onArchive: () {},
              onCompleteAll: () {
                setState(() {
                  bool setValue = todoCompletion != 1.0;
                  for (Map task in widget.todoData["task"]) {
                    task["completed"] = setValue;
                    for (Map tasks in task["tasks"]) {
                      tasks["completed"] = setValue;
                    }
                  }
                  todoCompletion = calculateCompletion(widget.todoData["task"]);
                });
                fileSyncSystem.syncFile(todoFileData!, jsonEncode(todoDataContent));
                setStateOnPagePop = true;
              },
              onDelete: () {
                showConfirmDialog(context, 'Delete "${widget.todoData["title"]}" permanently? This can\'t be undone!').then((value) {
                  if (value) {
                    setState(() {
                      todoContent.removeAt(widget.index);
                    });
                    fileSyncSystem.syncFile(todoFileData!, jsonEncode(todoDataContent));
                    setStateOnPagePop = true;
                    Navigator.pop(context, setStateOnPagePop);
                  }
                });
              },
              completeAllState: todoCompletion == 1.0,
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
                                      "Todo Prioirty: todos have different priorities. A todo has a general priority while its project tasks can have different priorities that are not linked to the general priority.",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: projectPriorities[widget.todoData["priority"]]),
                                  child: Text(
                                    "priority: ${widget.todoData["priority"]}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            //^ category visualisation
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                                child: checkCategoryValidity(widget.todoData["category"])
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
                                        child: AdaptiveText("category: ${widget.todoData["category"]}"),
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
                                          if (await showConfirmDialog(context, "Add '${widget.todoData["category"]}' to categories?")) {
                                            setState(() {
                                              String category = widget.todoData["category"];
                                              categoryDataContent!.add(category);
                                              categoryFilter[category] = true;
                                              categoryDataNeedSync = true;
                                              fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
                                              setStateOnPagePop = true;
                                            });
                                          }
                                        },
                                        child: AdaptiveText("Unknown Category: ${widget.todoData["category"]}"),
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
                                      progress: todoCompletion,
                                      progressColor: Colors.green,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Palette.bg,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                          side: BorderSide(color: Palette.text),
                                        ),
                                      ),
                                      child: AdaptiveText("completion: ${(todoCompletion * 100).toInt()}"),
                                    );
                                  }()),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdaptiveText(
                            widget.todoData["description"] == "" ? "No Description" : widget.todoData["description"],
                            fontStyle: widget.todoData["description"] == "" ? FontStyle.italic : null,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.todoData["task"].length,
                itemBuilder: (context, index) {
                  Map task = widget.todoData["task"][index];
                  return Card(
                    color: Palette.topbox,
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
                        icon: AdaptiveIcon(task["completed"] ? Icons.check_box : Icons.check_box_outline_blank),
                        onPressed: () {
                          setState(() {
                            task["completed"] = !task["completed"];
                            todoCompletion = calculateCompletion(widget.todoData["task"]);

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
