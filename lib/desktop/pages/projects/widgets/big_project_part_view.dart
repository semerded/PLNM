import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/content/default_file_content.dart';
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
  late Map currentActivePart;

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
                child: ListView(children: [
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
                ])),
          ),
        ],
      ),
    );
  }
}
