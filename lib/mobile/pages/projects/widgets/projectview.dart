import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/check_category_validity.dart';
import 'package:keeper_of_projects/common/functions/deadline_checker.dart';
import 'package:keeper_of_projects/common/functions/filter/filter.dart';
import 'package:keeper_of_projects/common/functions/filter/reset_filter.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/view_project_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:keeper_of_projects/common/custom/custom_one_border_painter.dart';

typedef OnUpdated = void Function();

class ProjectView extends StatefulWidget {
  final List content;
  final OnUpdated onUpdated;
  final TextEditingController searchBarController;
  const ProjectView({
    super.key,
    required this.content,
    required this.onUpdated,
    required this.searchBarController,
  });

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    return widget.content.isEmpty
        ? Center(
            child: AdaptiveText(
              "No projects found\nCreate new ideas / projects\nor recover projects from the archive",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          )
        : () {
            List<Map> filteredList = [];
            for (Map project in widget.content) {
              if (!itemFilteredOut(project)) {
                filteredList.add(project);
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
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400, childAspectRatio: 4),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                Map project = filteredList[index];
                double projectCompletion = calculateCompletion(project["part"]);
                return Card(
                  shape: Border(
                    left: BorderSide(
                      width: 10,
                      color: projectPriorities[project["priority"]],
                    ),
                  ),
                  color: Palette.box1,
                  elevation: 2,
                  child: CustomPaint(
                    painter: settingsDataContent!["showProjectSize"]
                        ? OneSideProgressBorderPainter(
                            color: Palette.primary,
                            progress: project["size"] == null ? 0 : project["size"] / 100,
                            strokeWidth: 3.0,
                            side: borderSide.bottom,
                          )
                        : null,
                    child: ListTile(
                      textColor: Palette.text,
                      title: AdaptiveText(
                        project["title"],
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      subtitle: RichText(
                        text: TextSpan(
                          children: [
                            if (!checkCategoryValidity(project["category"]))
                              const TextSpan(
                                text: "[!category not found!] • ",
                                style: TextStyle(color: Colors.red),
                              ),
                            if (project["due"] != null)
                              TextSpan(
                                text: deadlineChecker(dueDateFormater.parse(project["due"])),
                                style: TextStyle(
                                  color: overdue(dueDateFormater.parse(project["due"])) ? Colors.red : Palette.text,
                                ),
                              ),
                            TextSpan(
                              text: "${project["description"].length == 0 ? '' : ' • '}${project["description"]}",
                              style: TextStyle(
                                color: Palette.subtext,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => setState(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute<bool>(
                            builder: (context) => ProjectViewPage(
                              index: index,
                              projectData: project,
                            ),
                          ),
                        ).then((callback) {
                          if (callback != null) {
                            if (callback) {
                              setState(() {});
                              widget.onUpdated();
                            }
                          }
                        });
                      }),
                      trailing: CircularPercentIndicator(
                        radius: 24,
                        animation: true,
                        percent: projectCompletion,
                        progressColor: Colors.green,
                        center: AdaptiveText("${(projectCompletion * 100).toInt()}%"),
                      ),
                    ),
                  ),
                );
              },
            );
          }();
  }
}
