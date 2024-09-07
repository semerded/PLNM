// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/widgets/bottom_navigation_bar.dart';
import 'package:keeper_of_projects/common/widgets/google_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/home/functions/search_most_progressed.dart';
import 'package:keeper_of_projects/screens/home/widgets/home_page_title_divider.dart';
import 'package:keeper_of_projects/screens/home/widgets/preview_tile.dart';
import 'package:keeper_of_projects/screens/projects/projects_page.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List mostProgressedProjects;
  @override
  void initState() {
    // TODO: implement initState
    mostProgressedProjects = searchMostProgressedProjects(2);
    print(mostProgressedProjects);
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
                Column(
                  children: [
                    PreviewTile(
                      title: mostProgressedProjects[0]["title"],
                      completion: calculateCompletion(mostProgressedProjects[0]["part"]),
                    ),
                    PreviewTile(
                      title: mostProgressedProjects[1]["title"],
                      completion: calculateCompletion(mostProgressedProjects[1]["part"]),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: IconButton(
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Palette.box,
                      // minimumSize: const Size.fromHeight(double.maxFinite),
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
                )
              ],
            ),
          ),
          // ignore: prefer_const_constructors
          bottomNavigationBar: CustomBottomNavitagionBar() //? ignore const so the color can be updated with setstate
          ),
    );
  }
}
