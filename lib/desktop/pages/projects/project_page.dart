// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/animated_searchbar.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/projects/add_project_page.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/big_projectview.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/filter_search_bar.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/small_projectview.dart';
import 'package:keeper_of_projects/desktop/widgets/navigation_rail.dart';
import 'package:keeper_of_projects/desktop/widgets/top_bar.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final String ddb_categoryDefaultValue = "All";
  List<String> ddb_category = [];

  final filterController = TextEditingController();

  final FocusNode searchBarFocusNode = FocusNode();

  late String ddb_sortBy_value;
  late String ddb_category_value;

  void buildDDBcategory() {
    ddb_category = [];
    ddb_category_value = ddb_categoryDefaultValue;
    ddb_category.add(ddb_categoryDefaultValue);
    ddb_category.addAll(categoryDataContent!);
  }

  @override
  void initState() {
    super.initState();

    buildDDBcategory();
  }

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
                leading: AddButtonAnimated(
                  taskCreated: (value) {},
                  routTo: AddProjectPage(),
                  animateWhen: projectsDataContent!["projects"].length == 0,
                ),
                onUpdated: () => setState(() {}),
              ),
            ),
            Expanded(
              child: Column(
                children: () {
                  List<Widget> children = [];
                  children.add(
                    TopBar(
                      text: "You have ${projectsContent.length} project${projectsContent.length != 1 ? "s" : ""}",
                      onUpdated: () {
                        setState(() {});
                      },
                      actions: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: searchBarActive ? Palette.primary : Palette.box1,
                          child: IconButton(
                            color: searchBarActive ? Palette.box1 : Palette.primary,
                            onPressed: () {
                              setState(() {
                                searchBarActive = !searchBarActive;
                                searchBarActive ? FocusScope.of(context).requestFocus(searchBarFocusNode) : FocusManager.instance.primaryFocus?.unfocus();
                              });
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ],
                    ),
                  );

                  children.add(
                    AnimatedSearchBar(
                      filterController: filterController,
                      searchBarActive: searchBarActive,
                      focusNode: searchBarFocusNode,
                      onUpdated: (value) => setState(() {
                        searchBarValue = value;
                      }),
                      backgroundColor: Palette.box1,
                    ),
                  );

                  if (MediaQuery.sizeOf(context).width < bigProjectThreshold) {
                    children.addAll([
                      FilterSearchBar(
                        filterController: filterController,
                        searchBarFocusNode: searchBarFocusNode,
                        onUpdated: () {
                          setState(() {});
                        },
                      ),
                      AnimatedSearchBar(
                        filterController: filterController,
                        searchBarActive: searchBarActive,
                        focusNode: searchBarFocusNode,
                        onUpdated: (value) => setState(() {
                          searchBarValue = value;
                        }),
                      ),
                      SmallProjectView(
                        searchBarController: filterController,
                        content: projectsContent,
                        onUpdated: () => setState(() {}),
                      )
                    ]);
                  } else {
                    children.add(
                      BigProjectView(
                        filterController: filterController,
                        searchBarFocusNode: searchBarFocusNode,
                        onUpdated: () {
                          setState(() {});
                        },
                      ),
                    );
                  }
                  return children;
                }(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
