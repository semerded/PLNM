// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/home/functions/search_most_progressed.dart';
import 'package:keeper_of_projects/mobile/pages/home/widgets/home_page_title_divider.dart';
import 'package:keeper_of_projects/mobile/pages/home/widgets/project_preview_tile_grid.dart';
import 'package:keeper_of_projects/mobile/pages/home/widgets/task_preview_tile_grid.dart';
import 'package:keeper_of_projects/mobile/widgets/bottom_navigation_bar.dart';
import 'package:keeper_of_projects/mobile/widgets/google_pop_up_menu.dart';

// import 'package:keeper_of_projects/screens/home/widgets/project_preview_tile_grid.dart';
// import 'package:keeper_of_projects/screens/home/widgets/task_preview_tile_grid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List mostProgressedProjects;
  late List mostProgressedTasks;
  @override
  void initState() {
    // TODO: implement initState
    mostProgressedProjects = searchMostProgressedProjects(2);
    mostProgressedTasks = searchMostProgressedTasks(2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: Palette.bg,
          appBar: AppBar(
            backgroundColor: Palette.primary,
            title: Text("Home"),
            automaticallyImplyLeading: false,
            actions: [
              GooglePopUpMenu(
                onClose: (value) {
                  if (value) {
                    if (projectCategoriesNeedRebuild) {
                      projectCategoriesNeedRebuild = false;
                    }
                    setState(() {});
                  }
                },
                showArchive: false,
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Card(
                  elevation: 3,
                  color: Palette.topbox,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Hero(
                          tag: "",
                          child: GoogleUserCircleAvatar(
                            identity: currentUser!,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: AdaptiveText(
                            "Welcome ${currentUser!.displayName}!",
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                HomePageTitleDivider(
                  title: "Projects",
                  titleDividerInfo: [
                    TitleDividerInfo(
                      Icons.addchart,
                      projectsDataContent!["projects"].length,
                    ),
                    TitleDividerInfo(
                      Icons.lightbulb,
                      projectsDataContent!["ideas"].length,
                    )
                  ],
                ),
                ProjectPreviewTileGrid(
                  mostProgressedProjects: mostProgressedProjects,
                  projectNavigationCallback: (value) {
                    if (value) {
                      setState(() {
                        projectsContent = projectsDataContent!["projects"].toList();
                        mostProgressedProjects = searchMostProgressedProjects(2);
                      });
                    }
                  },
                ),
                HomePageTitleDivider(
                  title: "Task",
                  titleDividerInfo: [
                    TitleDividerInfo(Icons.task, taskContent.length),
                  ],
                ),
                TaskPreviewTileGrid(
                  mostProgressedTask: mostProgressedTasks,
                  taskNavigationCallback: (value) {
                    if (value) {
                      setState(() {
                        taskContent = taskDataContent!["task"].toList();
                        mostProgressedTasks = searchMostProgressedTasks(2);
                      });
                    }
                  },
                )
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar() //? ignore const so the color can be updated with setstate
          ),
    );
  }
}
