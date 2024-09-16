// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/search_index_from_maplist_with_id.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/bottom_navigation_bar.dart';
import 'package:keeper_of_projects/common/widgets/google_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/home/functions/search_most_progressed.dart';
import 'package:keeper_of_projects/screens/home/widgets/home_page_title_divider.dart';
import 'package:keeper_of_projects/screens/home/widgets/preview_tile.dart';
import 'package:keeper_of_projects/screens/projects/add_project_page.dart';
import 'package:keeper_of_projects/screens/projects/projects_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keeper_of_projects/screens/projects/view_project_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List mostProgressedProjects;
  late int testheight;
  @override
  void initState() {
    // TODO: implement initState
    mostProgressedProjects = searchMostProgressedProjects(2);
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
                StaggeredGrid.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    children: () {
                      List<Widget> children = [];
                      if (mostProgressedProjects.isNotEmpty) {
                        children.add(
                          StaggeredGridTile.count(
                            crossAxisCellCount: 4,
                            mainAxisCellCount: 1,
                            child: PreviewTile(
                              title: mostProgressedProjects[0]["title"],
                              completion: calculateCompletion(mostProgressedProjects[0]["part"]),
                              navigateToOnClick: ProjectViewPage(
                                index: searchIndexFromMaplist(mostProgressedProjects[0], projectsContent),
                                projectData: mostProgressedProjects[0],
                              ),
                              navigateCallBack: (value) {
                                if (value) {
                                  setState(() {
                                    projectsContent = projectsContent.toList();
                                    mostProgressedProjects = searchMostProgressedProjects(2);
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      }

                      if (mostProgressedProjects.length > 1) {
                        children.add(
                          StaggeredGridTile.count(
                            crossAxisCellCount: 4,
                            mainAxisCellCount: 1,
                            child: PreviewTile(
                              navigateToOnClick: ProjectViewPage(
                                index: searchIndexFromMaplist(mostProgressedProjects[1], projectsContent),
                                projectData: mostProgressedProjects[1],
                              ),
                              navigateCallBack: (value) {
                                if (value) {
                                  setState(() {
                                    projectsContent = projectsContent.toList();
                                    mostProgressedProjects = searchMostProgressedProjects(2);
                                  });
                                }
                              },
                              title: mostProgressedProjects[1]["title"],
                              completion: calculateCompletion(mostProgressedProjects[1]["part"]),
                            ),
                          ),
                        );
                      }

                      if (mostProgressedProjects.length < 2) {
                        children.add(
                          StaggeredGridTile.count(
                            crossAxisCellCount: 4,
                            mainAxisCellCount: mostProgressedProjects.isEmpty ? 2 : 1,
                            child: Card(
                              margin: const EdgeInsets.all(0),
                              color: Palette.box,
                              child: Center(
                                child: ListTile(
                                  title: AdaptiveText("Add more projects!"),
                                  trailing: AddButtonAnimated(
                                      taskCreated: (value) {
                                        if (value) {
                                          setState(() {
                                            projectsContent = projectsDataContent!["projects"].toList();
                                            mostProgressedProjects = searchMostProgressedProjects(2);
                                            // update screen when task is created
                                          });
                                        }
                                      },
                                      routTo: const AddProjectPage()),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      children.add(
                        StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 2,
                          child: IconButton(
                            style: IconButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Palette.box,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (context) {
                                    activePage = 4;
                                    return const ProjectPage();
                                  },
                                ),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            icon: AdaptiveIcon(Icons.arrow_forward_ios),
                          ),
                        ),
                      );

                      return children;
                    }()),
                HomePageTitleDivider(
                  title: "test",
                  titleDividerInfo: [],
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavitagionBar() //? ignore const so the color can be updated with setstate
          ),
    );
  }
}
