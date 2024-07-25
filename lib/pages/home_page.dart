// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/backend/google_api/google_api.dart';
import 'package:keeper_of_projects/widgets/google_pop_up_menu.dart';
import 'package:keeper_of_projects/widgets/home/add_project.dart';
import 'package:keeper_of_projects/widgets/home/animated_searchbar.dart';
import 'package:keeper_of_projects/widgets/home/projectview.dart';

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
  final List<String> ddb_sortBy = ["Created (Latest)", "Created (Oldest)", "Priority (Most)", "Priority (Least)", "Progress (Most)", "Progress (Least)"]; // TODO populate ddb lists
  List<String> ddb_category = ["all"];

  final FocusNode searchBarFocusNode = FocusNode();

  int availableTasks = 0;
  late String ddb_sortBy_value;
  late String ddb_category_value;

  @override
  void initState() {
    super.initState();

    ddb_sortBy_value = ddb_sortBy.first;
    ddb_category_value = ddb_category.first;
    ddb_category.addAll(projectCategories);
    projectsContent = userDataContent!["projects"];
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
                : const GooglePopUpMenu()
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
                        dropdownColor: Colors.red,
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
          taskCreated: (value) {
            print("$value unos");
            if (value) {
              print("$value thos");
              setState(() {
                projectsContent = userDataContent!["projects"];
                print(projectsContent);
                // update screen when task is created
              });
            }
          },
        ),
      ),
    );
  }
}
