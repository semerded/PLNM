import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:keeper_of_projects/common/widgets/bottom_navigation_bar.dart';
import 'package:keeper_of_projects/common/widgets/google_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/home/widgets/preview_tile.dart';
import 'package:keeper_of_projects/screens/projects/project_archive_page.dart';
import 'package:keeper_of_projects/screens/projects/projects_page.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(children: [
                    AdaptiveText(
                      "Projects  ",
                      fontSize: 24,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Divider(
                          height: 2,
                          thickness: 2,
                          color: Palette.subtext,
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(
                            child: AdaptiveIcon(
                              Icons.add_chart,
                              size: 14,
                              color: Palette.subtext,
                            ),
                          ),
                          TextSpan(
                            style: TextStyle(color: Palette.subtext),
                            text: projectsContent.length.toString(),
                          ),
                          WidgetSpan(
                            child: AdaptiveIcon(
                              Icons.lightbulb,
                              size: 14,
                              color: Palette.subtext,
                            ),
                          ),
                          TextSpan(
                            style: TextStyle(color: Palette.subtext),
                            text: ideasContent.length.toString(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Divider(
                          height: 2,
                          thickness: 2,
                          color: Palette.subtext,
                        ),
                      ),
                    ),
                  ]),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PreviewTile(
                        title: "test",
                        bottomWidget: LinearPercentIndicator(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: PreviewTile(
                        title: "test",
                        bottomWidget: LinearPercentIndicator(),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 70,
                        child: IconButton(
                          style: IconButton.styleFrom(
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
                              setStawte(() {});
                            });
                          },
                          icon: const AdaptiveIcon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ignore: prefer_const_constructors
          bottomNavigationBar: CustomBottomNavitagionBar() //? ignore const so the color can be updated with setstate
          ),
    );
  }
}
