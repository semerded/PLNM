import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/check_category_validity.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_button_info_dialog.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

typedef OnIndexChange = void Function(int index);

late Map currentActivePart;

class BigProjectPartView extends StatefulWidget {
  final Map projectData;
  final int currentPartIndex;
  final OnIndexChange onIndexChange;
  const BigProjectPartView({
    super.key,
    required this.projectData,
    required this.currentPartIndex,
    required this.onIndexChange,
  });

  @override
  State<BigProjectPartView> createState() => _BigProjectPartViewState();
}

class _BigProjectPartViewState extends State<BigProjectPartView> {
  Widget slideTransitionCard1 = Padding(
    padding: const EdgeInsets.all(8.0),
    key: const ValueKey(1),
    child: Container(
      color: Palette.box2,
    ),
  );
  Widget? slideTransitionCard2;
  bool slideTransitionReversed = false;

  @override
  void initState() {
    super.initState();
    currentActivePart = widget.projectData["part"][widget.currentPartIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                //^ priority visualization

                Row(
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
                        child: checkCategoryValidity(widget.projectData["category"])
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
                                child: AdaptiveText("category: ${widget.projectData["category"]}"),
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
                                  if (await showConfirmDialog(context, "Add '${widget.projectData["category"]}' to categories?")) {
                                    setState(() {
                                      String category = widget.projectData["category"];
                                      categoryDataContent!.add(category);
                                      categoryFilter[category] = true;
                                      categoryDataNeedSync = true;
                                      fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
                                      // setStateOnPagePop = true;
                                    });
                                  }
                                },
                                child: AdaptiveText("Unknown Category: ${widget.projectData["category"]}"),
                              ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.projectData["part"].length,
                    itemBuilder: (context, index) {
                      Map part = widget.projectData["part"][index];
                      double partCompletion = calculateCompletion(part["tasks"]);

                      return Transform.translate(
                        offset: Offset(index == widget.currentPartIndex ? 18 : 0, 0),
                        child: Card(
                          elevation: 5,
                          color: index == widget.currentPartIndex ? Palette.box3 : Palette.box1,
                          child: ListTile(
                            title: AdaptiveText(part["title"]),
                            subtitle: Text(
                              part["description"],
                              style: TextStyle(color: Palette.subtext),
                            ),
                            trailing: CircularPercentIndicator(
                              radius: 24,
                              animation: true,
                              progressColor: Colors.green,
                              center: Text(
                                "${(partCompletion * 100).toInt()}%",
                                style: TextStyle(color: Palette.subtext),
                              ),
                              percent: () {
                                return partCompletion.toDouble() / 100;
                              }(),
                            ),
                            onTap: () {
                              setState(() {
                                widget.onIndexChange(index);
                                currentActivePart = widget.projectData["part"][index];

                                // slide animation for content of project part view card

                                slideTransitionReversed = !slideTransitionReversed;
                                if (slideTransitionReversed) {
                                  slideTransitionCard2 = slideTransitionCard1;
                                  slideTransitionCard1 = ProjectPartViewCardContent(key: ValueKey(1));
                                } else {
                                  slideTransitionCard1 = slideTransitionCard2!;
                                  slideTransitionCard2 = ProjectPartViewCardContent(key: ValueKey(2));
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Card(
              elevation: 0,
              color: Palette.box3,
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    final slideAnimation = Tween<Offset>(
                      begin: Offset(0.0, 1.0), // Start position (right of the screen)
                      end: Offset(0.0, 0.0), // End position (in place)
                    ).animate(animation);

                    return SlideTransition(
                      position: slideAnimation,
                      child: child,
                    );
                  },
                  child: () {
                    slideTransitionCard2 = ProjectPartViewCardContent(key: ValueKey(2));
                    return slideTransitionReversed ? slideTransitionCard1 : slideTransitionCard2!;
                  }(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectPartViewCardContent extends StatefulWidget {
  const ProjectPartViewCardContent({super.key});

  @override
  State<ProjectPartViewCardContent> createState() => _ProjectPartViewCardContentState();
}

class _ProjectPartViewCardContentState extends State<ProjectPartViewCardContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Palette.box3,
        child: ListView(
          children: [
            currentActivePart["tasks"].length == 0
                ? AdaptiveText("No tasks")
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: currentActivePart["tasks"].length,
                    itemBuilder: (context, index) {
                      Map task = currentActivePart["tasks"][index];
                      return Card(
                        color: Palette.box4,
                        child: ListTile(
                          title: AdaptiveText(task["title"]),
                          subtitle: Text(
                            task["description"],
                            style: TextStyle(color: Palette.subtext),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
