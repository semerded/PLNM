// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_category_toggle.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/functions/filter/reset_filter.dart';
import 'package:keeper_of_projects/common/functions/filter/widgets/menu_items_header.dart';
import 'package:keeper_of_projects/common/functions/main_page_pop_scope.dart';
import 'package:keeper_of_projects/common/widgets/bottom_navigation_bar.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/projects/add_project_page.dart';
import 'package:keeper_of_projects/common/widgets/google_pop_up_menu.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/animated_searchbar.dart';
import 'package:keeper_of_projects/screens/projects/ideas_page.dart';
import 'package:keeper_of_projects/screens/projects/project_archive_page.dart';
import 'package:keeper_of_projects/screens/projects/widgets/projectview.dart';
import 'package:keeper_of_projects/screens/todo/add_todo_page.dart';
import 'package:keeper_of_projects/screens/todo/widgets/todoview.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  SnackBar sb_connectionErr = SnackBar(content: AdaptiveText("A connection error has occurd"));
  final SnackBar sb_fileUploadErr = SnackBar(content: AdaptiveText("File coulnd't be uploaded, try again later"));
  final SnackBar sb_fileDownloadErr = SnackBar(content: AdaptiveText("File couldn't be downloaded, try again later"));
  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  final List<String> ddb_sortBy = ["Created (Latest)", "Created (Oldest)", "Priority (Highest)", "Priority (Lowest)", "Progress (Most)", "Progress (Least)", "Size (Biggest)", "Size (Smallest)"];
  final String ddb_categoryDefaultValue = "All";
  List<String> ddb_category = [];
  final FocusNode _buttonFocusNode = FocusNode();

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

    ddb_sortBy_value = ddb_sortBy.first;
    buildDDBcategory();
  }

  @override
  Widget build(BuildContext context) {
    return MainPagePopScope(
      child: Scaffold(
          backgroundColor: Palette.bg,
          appBar: AppBar(
            backgroundColor: Palette.primary,
            title: Text("You have ${todoContent.length} thing${todoContent.length == 1 ? "" : "s"} todo"), //? add extra s if task is not equal to 1 to make it plural
            automaticallyImplyLeading: false,
            actions: [
              GooglePopUpMenu(
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
              Padding(
                padding: const EdgeInsets.only(left: 4, right: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MenuAnchor(
                        style: MenuStyle(backgroundColor: WidgetStatePropertyAll(Palette.topbox)),
                        childFocusNode: _buttonFocusNode,
                        menuChildren: () {
                          List<Widget> menuItems = [];
                          menuItems.add(
                            MenuItemsHeader(
                              text: "Priorities",
                              onClick: () {
                                setState(() {
                                  filterCategoryToggle(priorityFilter);
                                });
                              },
                              anyFilterEnabled: priorityFilter.every((priority) => !priority), //? reverse bool to only enable all when nothing is enabled, otherwise disable if any (not all) are enabled
                            ),
                          );
                          for (int i = 0; i < projectPriorities.length; i++) {
                            menuItems.add(
                              CheckboxMenuButton(
                                closeOnActivate: false,
                                value: priorityFilter[i],
                                onChanged: (bool? value) {
                                  setState(() {
                                    priorityFilter[i] = !priorityFilter[i];
                                  });
                                },
                                child: AdaptiveText(projectPriorities.keys.toList()[i]),
                              ),
                            );
                          }
                          menuItems.add(
                            MenuItemsHeader(
                              text: "Categories",
                              onClick: () {
                                setState(() {
                                  bool updateTo = categoryFilter.values.every((value) => !value);
                                  categoryFilter.updateAll((category, value) => value = updateTo);
                                });
                              },
                              anyFilterEnabled: categoryFilter.values.every((category) => !category),
                            ),
                          );
                          for (String category in categoryFilter.keys) {
                            menuItems.add(
                              CheckboxMenuButton(
                                closeOnActivate: false,
                                value: categoryFilter[category],
                                onChanged: (bool? value) {
                                  setState(() {
                                    categoryFilter[category] = !categoryFilter[category]!;
                                  });
                                },
                                child: AdaptiveText(category),
                              ),
                            );
                          }
                          return menuItems;
                        }(),
                        builder: (BuildContext context, MenuController controller, Widget? child) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Palette.box),
                            focusNode: _buttonFocusNode,
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            child: AdaptiveText('Filter'),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          resetFilter();
                          filterController.clear();
                        });
                      },
                      style: IconButton.styleFrom(backgroundColor: Colors.red),
                      tooltip: "Remove All Filters",
                      icon: AdaptiveIcon(Icons.filter_alt_off),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          color: Palette.box,
                          child: DropdownButton<String>(
                            padding: const EdgeInsets.only(left: 7, right: 7),
                            elevation: 15,
                            isExpanded: true,
                            dropdownColor: Palette.topbox,
                            value: ddb_sortBy_value,
                            items: ddb_sortBy.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: AdaptiveText(
                                  value,
                                  overflow: TextOverflow.fade,
                                ),
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
                      backgroundColor: searchBarActive ? Palette.primary : Palette.box,
                      child: IconButton(
                        color: searchBarActive ? Palette.box : Palette.primary,
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
              ),
              AnimatedSearchBar(
                filterController: filterController,
                searchBarActive: searchBarActive,
                focusNode: searchBarFocusNode,
                onUpdated: (value) => setState(() {
                  searchbarValue = value;
                }),
              ),
              Expanded(
                child: TodoView(
                  searchbarController: filterController,
                  content: todoContent,
                  onUpdated: () => setState(() {}),
                ),
              ),
            ],
          ),
          floatingActionButton: AddButtonAnimated(
            routTo: const AddTodoPage(),
            taskCreated: (value) {
              if (value) {
                setState(() {
                  todoContent = todoDataContent!["todo"];
                  // update screen when task is created
                });
              }
            },
            animateWhen: todoDataContent!["todo"].length == 0,
          ),
          // ignore: prefer_const_constructors
          bottomNavigationBar: CustomBottomNavitagionBar() //? ignore const so the color can be updated with setstate
          ),
    );
  }
}
