import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/animated_searchBar.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/tasks/task_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/big_project_part_view.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/filter_search_bar.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/small_project_part_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

typedef OnUpdated = void Function();

late Map currentActiveProject;
late double projectCompletion;
int currentPartIndex = 0;

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
  Widget slideTransitionCard1 = Padding(
    padding: const EdgeInsets.all(8.0),
    key: const ValueKey(1),
    child: Container(
      color: Palette.box2,
    ),
  );
  Widget? slideTransitionCard2;
  bool slideTransitionReversed = false;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentActiveProject = projectsContent[activeProject_BigProjectView];
    projectCompletion = calculateCompletion(currentActiveProject["part"]);
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
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: projectsContent.length,
                  itemBuilder: (context, index) {
                    Map project = projectsContent[index];

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.translationValues(activeProject_BigProjectView == index ? 18 : 0, 0, 0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Set border radius on Card
                        ),
                        clipBehavior: Clip.antiAlias,
                        color: activeProject_BigProjectView == index ? Palette.box2 : Palette.box1,
                        child: Container(
                          decoration: activeProject_BigProjectView == index
                              ? null
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
                              if (index != currentIndex) {
                                setState(() {
                                  currentIndex = index;
                                  activeProject_BigProjectView = index;
                                  currentActiveProject = projectsContent[index];
                                  currentPartIndex = 0;

                                  // slide animation for content of project view card

                                  slideTransitionReversed = !slideTransitionReversed;
                                  if (slideTransitionReversed) {
                                    slideTransitionCard2 = slideTransitionCard1;
                                    slideTransitionCard1 = ProjectViewCardContent(key: ValueKey(1));
                                  } else {
                                    slideTransitionCard1 = slideTransitionCard2!;
                                    slideTransitionCard2 = ProjectViewCardContent(key: ValueKey(2));
                                  }
                                });
                              }
                            },
                          ),
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
              color: Palette.box2,
              elevation: 0,
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    final slideAnimation = Tween<Offset>(
                      begin: Offset(1.0, 0.0), // Start position (right of the screen)
                      end: Offset(0.0, 0.0), // End position (in place)
                    ).animate(animation);

                    return SlideTransition(
                      position: slideAnimation,
                      child: child,
                    );
                  },
                  child: () {
                    slideTransitionCard2 = ProjectViewCardContent(key: ValueKey(2));
                    return slideTransitionReversed ? slideTransitionCard1 : slideTransitionCard2!;
                  }(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProjectViewCardContent extends StatefulWidget {
  const ProjectViewCardContent({super.key});

  @override
  State<ProjectViewCardContent> createState() => _ProjectViewCardContentState();
}

class _ProjectViewCardContentState extends State<ProjectViewCardContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Palette.box2,
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
            MediaQuery.sizeOf(context).width > bigProjectPartThreshold
                ? BigProjectPartView(
                    projectData: currentActiveProject,
                    currentPartIndex: currentPartIndex,
                    onIndexChange: (index) => setState(() {
                      currentPartIndex = index;
                    }),
                  )
                : SmallProjectPartView(
                    projectData: currentActiveProject,
                  )
          ],
        ),
      ),
    );
  }
}
