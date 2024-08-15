import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/common/custom/progress_elevated_button.dart';
import 'package:keeper_of_projects/common/enum/page_callback.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/tasks/task_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/projects/edit_project_page.dart';
import 'package:keeper_of_projects/screens/projects/view_project_part_page.dart';
import 'package:keeper_of_projects/screens/projects/widgets/project_button_info_dialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProjectViewPage extends StatefulWidget {
  Map projectData;
  final int index;
  ProjectViewPage({required this.projectData, required this.index, super.key});

  @override
  State<ProjectViewPage> createState() => _ProjectViewPageState();
}

class _ProjectViewPageState extends State<ProjectViewPage> {
  late double projectCompletion = calculateCompletion(widget.projectData["part"]);
  PageCallback pageCallback = PageCallback.none;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, pageCallback);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, pageCallback),
          ),
          title: Text(widget.projectData["title"]),
          actions: [
            TaskPopUpMenu(
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Map>(
                    builder: (context) => EditProjectPage(projectData: widget.projectData,),
                  ),
                ).then((callback) async {
                  if (callback != null) {
                    setState(() {
                      projectsContent[widget.index] = Map.from(callback);
                      widget.projectData = Map.from(callback);
                      pageCallback = PageCallback.setState; // TODO
                    });
                    await saveFile(projectsFileData!.id!, jsonEncode(projectsDataContent));
                  }
                });
              },
              onArchive: () {},
              onCompleteAll: () {
                pageCallback = PageCallback.setStateAndSync;
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
              },
              onDelete: () {},
              completeAllState: projectCompletion == 1.0,
              archiveState: false,
            ),
          ],
        ),
        body: Column(
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
                          "Project Prioirty: projects have different priorities. A project has a general priority while its project parts can have different priorities that are not linked to the general priority.",
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: projectPriorities[widget.projectData["priority"]]),
                      child: Text(
                        "priority: ${widget.projectData["priority"]}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                //^ category visualisation
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: ElevatedButton(
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
                      child: AdaptiveText("category: ${widget.projectData["category"]}"),
                    ),
                  ),
                )
              ],
            ),
            Row(
              //^ project size visualisation
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: ProgressElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.bg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Palette.text),
                        ),
                      ),
                      onPressed: () {
                        showInfoDialog(
                          context,
                          "Project Size: Shows the size of the project, the description converts a percental scale to something more readable. The background shows the percental scale.",
                        );
                      },
                      progress: () {
                        int size = widget.projectData["size"];
                        return size.toDouble() / 100;
                      }(),
                      progressColor: Palette.primary,
                      child: Text(
                        () {
                          List<String> currentProjectSizeDescription = settingsDataContent!["funnyProjectSize"] ? projectSizeDescriptionAlternative : projectSizeDescription;
                          if (widget.projectData["size"] == 0) {
                            return currentProjectSizeDescription[0];
                          }
                          double value = ((widget.projectData["size"] - 1) / projectSizeDescriptionSubdivisionNumber) + 1;
                          return currentProjectSizeDescription[value.toInt()];
                        }(),
                        style: TextStyle(color: Palette.text),
                      ),
                    ),
                  ),
                ),
                //^ completion visualisation
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: () {
                        return ProgressElevatedButton(
                          onPressed: () {
                            showInfoDialog(
                              context,
                              "Project completion, This shows how much of the project parts have been completed.",
                            );
                          },
                          progress: projectCompletion,
                          progressColor: Colors.green,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.bg,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Palette.text),
                            ),
                          ),
                          child: AdaptiveText("completion: ${(projectCompletion * 100).toInt()}"),
                        );
                      }()),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AdaptiveText(
                widget.projectData["description"] == "" ? "No Description" : widget.projectData["description"],
                fontStyle: widget.projectData["description"] == "" ? FontStyle.italic : null,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.projectData["part"].length,
                itemBuilder: (context, index) {
                  Map part = widget.projectData["part"][index];
                  double partCompletion = calculateCompletion(part["tasks"]);
                  return Card(
                    color: Palette.topbox,
                    child: ListTile(
                      title: AdaptiveText(part["title"]),
                      subtitle: AdaptiveText(part["description"]),
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
                            ),
                          ),
                        ).then(
                          (callback) {
                            if (callback != null && callback) {
                              pageCallback = PageCallback.setStateAndSync;
                            }
                            setState(() {
                              partCompletion = calculateCompletion(part["tasks"]);
                              if (!partCompletion.isNaN) {
                                part["completed"] = partCompletion == 1.0;
                              }
                              projectCompletion = calculateCompletion(widget.projectData["part"]);
                            });
                          },
                        );
                      },
                      trailing: part["tasks"].length == 0
                          ? IconButton(
                              icon: AdaptiveIcon(part["completed"] ? Icons.check_box : Icons.check_box_outline_blank),
                              onPressed: () {
                                setState(() {
                                  part["completed"] = !part["completed"];
                                  projectCompletion = calculateCompletion(widget.projectData["part"]);
                                  pageCallback = PageCallback.setStateAndSync;
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
      ),
    );
  }
}
