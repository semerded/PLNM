import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/category.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/project_task/vis_category.dart';
import 'package:keeper_of_projects/common/widgets/project_task/vis_priority.dart';
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
  int currentIndex = 0;

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
                Row(
                  children: [
                    VisPriority(data: widget.projectData),
                    VisCategory(data: widget.projectData, onUpdated: () => setState(() {})),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.projectData["part"].length,
                    itemBuilder: (context, index) {
                      Map part = widget.projectData["part"][index];
                      double partCompletion = calculateCompletion(part["tasks"]);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        transform: Matrix4.translationValues(index == widget.currentPartIndex ? 18 : 0, 0, 0),
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
                              if (index != currentIndex) {
                                setState(() {
                                  currentIndex = index;
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
                              }
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
