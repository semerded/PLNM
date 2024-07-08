// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:keeper_of_projects/backend/backend.dart' as backend;
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/google_api/google_api.dart';
import 'package:keeper_of_projects/widgets/google_pop_up_menu.dart';

const List<String> ddb_sortBy = ["Created (Latest)", "Created (Oldest)", "Priority (Most)", "Priority (Least)", "Progress (Most)", "Progress (Least)"]; // TODO populate ddb lists
const List<String> ddb_category = ["all"];

void main() {
  runApp(const AppWrapper());
}

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
  final SnackBar sb_connectionErr = const SnackBar(content: Text("A connection error has occurd"));
  final SnackBar sb_fileUploadErr = const SnackBar(content: Text("File coulnd't be uploaded, try again later"));
  final SnackBar sb_fileDownloadErr = const SnackBar(content: Text("File couldn't be downloaded, try again later"));
  // ScaffoldMessenger.of(context).showSnackBar(snackBar);

  int availableTasks = 0;

  String ddb_sortBy_value = ddb_sortBy.first;
  String ddb_category_value = ddb_category.first;
  bool searchBarActive = false;

  @override
  void initState() {
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        currentUser = account;
      });
      backend.init(); // initialize backend
    });
    googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.primary,
          title: Text("$availableTasks task${availableTasks == 1 ? "" : "s"}"), //? add extra s if task is not equal to 1
          leading: FloatingActionButton(
            onPressed: () {}, // TODO go to idea page
            backgroundColor: Pallete.primary,
            elevation: 0,
            child: const Icon(Icons.lightbulb),
          ),
          actions: [
            currentUser == null
                ? FloatingActionButton(
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
                            child: Text(value),
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
                            child: Text(value),
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
                    onPressed: () {
                      setState(() {
                        searchBarActive = !searchBarActive;
                      });
                    },
                    color: Pallete.primary,
                    icon: const Icon(Icons.search),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
