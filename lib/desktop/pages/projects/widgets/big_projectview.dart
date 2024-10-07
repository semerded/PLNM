import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/custom/progress_elevated_button.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/check_category_validity.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/animated_searchBar.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/tasks/task_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/filter_search_bar.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/small_project_part_view.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_button_info_dialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

typedef OnUpdated = void Function();

class BigProjectView extends StatefulWidget {
  final TextEditingController filterController;
  final FocusNode searchBarFocusNode;
  final OnUpdated onUpdated;

  const BigProjectView({
    super.key,
    required this.filterController,
    required this.searchBarFocusNode,
    required this.onUpdated,
  });

  @override
  State<BigProjectView> createState() => _BigProjectViewState();
}

class _BigProjectViewState extends State<BigProjectView> {
  late Map currentActiveProject;
  late double projectCompletion;

  @override
  void initState() {
    currentActiveProject = projectsContent[activeProject_BigProjectView];
    projectCompletion = calculateCompletion(currentActiveProject["part"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                FilterSearchBar(
                  filterController: widget.filterController,
                  searchBarFocusNode: widget.searchBarFocusNode,
                  onUpdated: () {
                    setState(() {});
                  },
                ),
                AnimatedSearchBar(
                  filterController: widget.filterController,
                  searchBarActive: searchBarActive,
                  focusNode: widget.searchBarFocusNode,
                  onUpdated: (value) => setState(() {
                    searchBarValue = value;
                  }),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: projectsContent.length,
                  itemBuilder: (context, index) {
                    Map project = projectsContent[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Set border radius on Card
                      ),
                      clipBehavior: Clip.antiAlias,
                      color: activeProject_BigProjectView == index ? Palette.box : Palette.topbox,
                      child: Container(
                        decoration: activeProject_BigProjectView == index
                            ? BoxDecoration(
                                border: Border.all(color: Palette.primary, width: 3),
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                              )
                            : BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                    width: 10,
                                    color: projectPriorities[project["priority"]],
                                  ),
                                ),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                        child: ListTile(
                          title: AdaptiveText(project["title"]),
                          onTap: () {
                            setState(() {
                              activeProject_BigProjectView = index;
                              currentActiveProject = projectsContent[index];
                            });
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: Card(
              color: Palette.topbox,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Palette.primary, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AdaptiveText(
                          currentActiveProject["title"],
                          fontSize: 32,
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                          child: CircularPercentIndicator(
                            radius: 32,
                            lineWidth: 10,
                            animation: true,
                            progressColor: Colors.green,
                            center: Text(
                              "${(projectCompletion * 100).toInt()}%",
                              style: TextStyle(color: Palette.subtext),
                            ),
                            percent: projectCompletion,
                            footer: AdaptiveText("Progress"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                          child: CircularPercentIndicator(
                            radius: 32,
                            lineWidth: 10,
                            animation: true,
                            progressColor: Colors.green,
                            percent: () {
                              int size = currentActiveProject["size"];
                              return size.toDouble() / 100;
                            }(),
                            footer: AdaptiveText("Size"),
                          ),
                        ),
                        TaskPopUpMenu(
                          icon: AdaptiveIcon(
                            Icons.more_vert,
                            size: 32,
                          ),
                          enabledTasks: const [TaskOptions.archive, TaskOptions.completeAll, TaskOptions.delete, TaskOptions.edit],
                          onEdit: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute<Map>(
                            //     builder: (context) => EditProjectPage(
                            //       projectData: currentActiveProject,
                            //     ),
                            //   ),
                            // ).then((callback) async {
                            //   if (callback != null) {
                            //     setState(() {
                            //       projectsContent[widget.index] = Map.from(callback);
                            //       currentActiveProject = Map.from(callback);
                            //       projectCompletion = calculateCompletion(currentActiveProject["part"]);
                            //       setStateOnPagePop = true;
                            //     });
                            //     await fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                            //   }
                            // });
                          },
                          onArchive: () {},
                          onCompleteAll: () {
                            // setState(() {
                            //   bool setValue = projectCompletion != 1.0;
                            //   for (Map part in currentActiveProject["part"]) {
                            //     part["completed"] = setValue;
                            //     for (Map tasks in part["tasks"]) {
                            //       tasks["completed"] = setValue;
                            //     }
                            //   }
                            //   projectCompletion = calculateCompletion(currentActiveProject["part"]);
                            // });
                            // fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                            // setState(() {});
                          },
                          onDelete: () {
                            // showConfirmDialog(context, 'Delete "${currentActiveProject["title"]}" permanently? This can\'t be undone!').then((value) {
                            //   if (value) {
                            //     setState(() {
                            //       projectsContent.removeAt(widget.index);
                            //     });
                            //     fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
                            //     setStateOnPagePop = true;
                            //     Navigator.pop(context, setStateOnPagePop);
                            //   }
                            // });
                          },
                          completeAllState: projectCompletion == 1.0,
                          archiveState: false,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    currentActiveProject["description"],
                    style: TextStyle(color: Palette.subtext),
                  ),
                  Expanded(child: SmallProjectPartView(projectData: currentActiveProject))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
