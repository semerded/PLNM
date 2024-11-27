import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/widgets/google_pop_up_menu.dart';
import 'package:keeper_of_projects/desktop/widgets/navigation_rail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomNavigationRail(
                onUpdated: () => setState(() {}),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Card(
                    elevation: 3,
                    color: Palette.box3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GooglePopUpMenu(onClose: (value) {
                            if (value) {
                              if (projectCategoriesNeedRebuild) {
                                projectCategoriesNeedRebuild = false;
                              }
                              setState(() {});
                            }
                          }),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
