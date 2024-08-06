// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/bottom_navigation_bar.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/screens/projects/add_project_page.dart';
import 'package:keeper_of_projects/common/widgets/google_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/add_animated.dart';
import 'package:keeper_of_projects/common/widgets/animated_searchbar.dart';
import 'package:keeper_of_projects/screens/projects/project_archive_page.dart';
import 'package:keeper_of_projects/screens/projects/widgets/projectview.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SnackBar sb_connectionErr = SnackBar(content: AdaptiveText("A connection error has occurd"));
  final SnackBar sb_fileUploadErr = SnackBar(content: AdaptiveText("File coulnd't be uploaded, try again later"));
  final SnackBar sb_fileDownloadErr = SnackBar(content: AdaptiveText("File couldn't be downloaded, try again later"));
  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  final List<String> ddb_sortBy = ["Created (Latest)", "Created (Oldest)", "Priority (Highest)", "Priority (Lowest)", "Progress (Most)", "Progress (Least)", "Size (Biggest)", "Size (Smallest)"];
  final String ddb_categoryDefaultValue = "All";
  List<String> ddb_category = [];

  final FocusNode searchBarFocusNode = FocusNode();

  int availableTasks = 0;
  late String ddb_sortBy_value;
  late String ddb_category_value;

  void buildDDBcategory() {
    ddb_category = [];
    ddb_category_value = ddb_categoryDefaultValue;
    ddb_category.add(ddb_categoryDefaultValue);
    ddb_category.addAll(projectCategories);
  }

  @override
  void initState() {
    super.initState();

    ddb_sortBy_value = ddb_sortBy.first;
    buildDDBcategory();
    projectsContent = projectsDataContent!["projects"];
  }

  bool searchBarActive = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: Pallete.bg,
          appBar: AppBar(
            backgroundColor: Pallete.primary,
            title: AdaptiveText("$availableTasks task${availableTasks == 1 ? "" : "s"}"), //? add extra s if task is not equal to 1 to make it plural
            automaticallyImplyLeading: false,
            actions: [
              currentUser == null
                  ? FloatingActionButton(
                      heroTag: null,
                      elevation: 0,
                      backgroundColor: Pallete.primary,
                      onPressed: () {
                        handleSignIn();
                      },
                      child: const Icon(Icons.login),
                    )
                  : GooglePopUpMenu(
                      onClose: (value) {
                        if (value) {
                          if (projectCategoriesNeedRebuild) {
                            buildDDBcategory();
                            projectCategoriesNeedRebuild = false;
                          }
                          setState(() {});
                        }
                      },
                      showArchive: true,
                      archiveRoute: const ArchivePage(),
                    )
            ],
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        color: Pallete.box,
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          isExpanded: true,
                          dropdownColor: Pallete.topbox,
                          elevation: 15,
                          value: ddb_category_value,
                          items: ddb_category.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: AdaptiveText(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              ddb_category_value = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        color: Pallete.box,
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.only(left: 7, right: 7),
                          elevation: 15,
                          isExpanded: true,
                          dropdownColor: Pallete.topbox,
                          value: ddb_sortBy_value,
                          items: ddb_sortBy.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: AdaptiveText(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              ddb_sortBy_value = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: searchBarActive ? Pallete.primary : Pallete.box,
                    child: IconButton(
                      color: searchBarActive ? Pallete.box : Pallete.primary,
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
              AnimatedSearchBar(
                searchBarActive: searchBarActive,
                focusNode: searchBarFocusNode,
              ),
              Expanded(
                child: ProjectView(
                  content: projectsContent,
                ),
              ),
            ],
          ),
          floatingActionButton: AddProject(
            routTo: const AddProjectPage(),
            taskCreated: (value) {
              if (value) {
                setState(() {
                  projectsContent = projectsDataContent!["projects"];
                  // update screen when task is created
                });
              }
            },
          ),
          // ignore: prefer_const_constructors
          bottomNavigationBar: CustomBottomNavitagionBar() //? ignore const so the color can be updated with setstate
          ),
    );
  }
}
