import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/filter/filter.dart';
import 'package:keeper_of_projects/common/functions/filter/reset_filter.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/project_task/card_description.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/tasks/task_view_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

typedef OnUpdated = void Function();

class TaskView extends StatefulWidget {
  final List content;
  final OnUpdated onUpdated;
  final TextEditingController searchBarController;
  const TaskView({
    super.key,
    required this.content,
    required this.onUpdated,
    required this.searchBarController,
  });

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {
    return widget.content.isEmpty
        ? Center(
            child: AdaptiveText(
              "No tasks found\nCreate new tasks\nor recover tasks from the archive",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          )
        : () {
            List<Map> filteredList = [];
            for (Map task in widget.content) {
              if (!itemFilteredOut(task)) {
                filteredList.add(task);
              }
            }
            if (filteredList.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdaptiveIcon(Icons.filter_alt_off),
                  AdaptiveText(
                    "You Filtered Everything!",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      resetFilter();
                      widget.searchBarController.clear();
                      widget.onUpdated();
                    }),
                    style: ElevatedButton.styleFrom(backgroundColor: Palette.primary),
                    child: const Text(
                      "Remove All Filters",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400, childAspectRatio: 4),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                Map task = filteredList[index];
                double taskCompletion = calculateCompletion(task["subTask"]);
                bool singleTask = task["subTask"].length == 0;
                return Card(
                  shape: Border(
                    left: BorderSide(
                      width: 10,
                      color: projectPriorities[task["priority"]],
                    ),
                  ),
                  color: Palette.box1,
                  elevation: 2,
                  child: ListTile(
                    textColor: Palette.text,
                    title: AdaptiveText(
                      task["title"],
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    subtitle: CardDescription(data: task),
                    onTap: () => setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute<bool>(
                          builder: (context) => TaskViewPage(
                            index: index,
                            taskData: task,
                          ),
                        ),
                      ).then((callback) {
                        if (callback != null && callback) {
                          setState(() {});
                          taskCompletion = calculateCompletion(widget.content[index]["subTask"]);

                          widget.onUpdated();
                        }
                      });
                    }),
                    trailing: singleTask
                        ? IconButton(
                            icon: AdaptiveIcon(
                              task["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
                              size: 36,
                            ),
                            onPressed: () {
                              setState(() {
                                task["completed"] = !task["completed"];
                                taskCompletion = calculateCompletion(widget.content[index]["subTask"]);

                                fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                                widget.onUpdated();
                              });
                            },
                          )
                        : CircularPercentIndicator(
                            radius: 24,
                            animation: true,
                            percent: taskCompletion,
                            progressColor: Colors.green,
                            center: AdaptiveText("${(taskCompletion * 100).toInt()}%"),
                          ),
                  ),
                );
              },
            );
          }();
  }
}
