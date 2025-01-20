import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/deadline_checker.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/tasks/task_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/project_task/view_due_date.dart';
import 'package:keeper_of_projects/common/widgets/project_task/vis_category.dart';
import 'package:keeper_of_projects/common/widgets/project_task/vis_completion.dart';
import 'package:keeper_of_projects/common/widgets/project_task/vis_priority.dart';
import 'package:keeper_of_projects/common/widgets/project_task/vis_project_size.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/edit_project_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/part/view_project_part_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

// ignore: must_be_immutable
class ProjectViewPage extends StatefulWidget {
  Map projectData;
  final int index;
  ProjectViewPage({required this.projectData, required this.index, super.key});

  @override
  State<ProjectViewPage> createState() => _ProjectViewPageState();
}

class _ProjectViewPageState extends State<ProjectViewPage> {
  late double projectCompletion = calculateCompletion(widget.projectData["part"]);
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
          title: Text(widget.projectData["title"]),
          actions: [
            TaskPopUpMenu(
              enabledTasks: const [TaskOptions.archive, TaskOptions.completeAll, TaskOptions.delete, TaskOptions.edit],
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Map>(
                    builder: (context) => EditProjectPage(
                      projectData: widget.projectData,
                    ),
                  ),
                ).then((callback) async {
                  if (callback != null) {
                    setState(() {
                      projectsContent[widget.index] = Map.from(callback);
                      widget.projectData = Map.from(callback);
                      projectCompletion = calculateCompletion(widget.projectData["part"]);
                      setStateOnPagePop = true;
                    });
                    await fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                  }
                });
              },
              onArchive: () {},
              onCompleteAll: () {
                setState(() {
                  bool setValue = projectCompletion != 1.0;
                  for (Map part in widget.projectData["part"]) {
                    part["completed"] = setValue;
                    for (Map tasks in part["tasks"]) {
                      tasks["completed"] = setValue;
                    }
                  }
                  projectCompletion = calculateCompletion(widget.projectData["part"]);
                });
                fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                setStateOnPagePop = true;
              },
              onDelete: () {
                showConfirmDialog(context, 'Delete "${widget.projectData["title"]}" permanently? This can\'t be undone!').then((value) {
                  if (value) {
                    setState(() {
                      projectsContent.removeAt(widget.index);
                    });
                    fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                    setStateOnPagePop = true;
                    Navigator.pop(context, setStateOnPagePop);
                  }
                });
              },
              completeAllState: projectCompletion == 1.0,
              archiveState: false,
            ),
          ],
        ),
        body: Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 500),
              child: projectDetailsVisible
                  ? Column(
                      children: [
                        Row(
                          children: [
                            VisPriority(data: widget.projectData),
                            VisCategory(
                                data: widget.projectData,
                                onUpdated: () => setState(() {
                                      setStateOnPagePop = true;
                                    }))
                          ],
                        ),
                        Row(
                          children: [
                            VisProjectSize(data: widget.projectData),
                            VisCompletion(projectCompletion: projectCompletion),
                          ],
                        ),
                        ViewDueDate(data: widget.projectData),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AdaptiveText(
                            widget.projectData["description"] == "" ? "No Description" : widget.projectData["description"],
                            fontStyle: widget.projectData["description"] == "" ? FontStyle.italic : null,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),

            ///////////////////////
            // project part list //
            ///////////////////////
            Expanded(
              child: ListView.builder(
                itemCount: widget.projectData["part"].length,
                itemBuilder: (context, index) {
                  Map part = widget.projectData["part"][index];
                  double partCompletion = calculateCompletion(part["tasks"]);
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
                      shape: Border(
                        left: BorderSide(
                          width: 10,
                          color: projectPriorities[part["priority"]],
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<bool>(
                            builder: (context) => ProjectPartViewPage(
                              part: part,
                              projectData: widget.projectData,
                              index: index,
                            ),
                          ),
                        ).then(
                          (callback) {
                            if (callback != null && callback) {
                              // fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                              setStateOnPagePop = true;
                            }
                            setState(() {
                              partCompletion = calculateCompletion(part["tasks"]);
                              if (!partCompletion.isNaN && part["tasks"].length > 0) {
                                part["completed"] = partCompletion == 1.0;
                              }
                              projectCompletion = calculateCompletion(widget.projectData["part"]);
                            });
                          },
                        );
                      },
                      trailing: part["tasks"].length == 0
                          ? IconButton(
                              icon: AdaptiveIcon(
                                part["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
                                size: 36,
                              ),
                              onPressed: () {
                                setState(() {
                                  part["completed"] = !part["completed"];
                                  projectCompletion = calculateCompletion(widget.projectData["part"]);
                                  fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                                  setStateOnPagePop = true;
                                });
                              },
                            )
                          : CircularPercentIndicator(
                              progressColor: Colors.green,
                              center: AdaptiveText("${(partCompletion * 100).toInt()}%"),
                              radius: 24,
                              animation: true,
                              percent: partCompletion,
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
