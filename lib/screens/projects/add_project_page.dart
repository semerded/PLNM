// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/common/widgets/textfield_border.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/common/widgets/loading_screen.dart';
import 'package:keeper_of_projects/screens/projects/widgets/project_size_slider.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  bool taskValidated = false;
  bool validTitle = false;
  bool validCategory = false;
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController descriptionController = TextEditingController();
  late String ddb_priority_value;
  late String ddb_category_value;

  Map<String, dynamic> newTask = {
    "title": null,
    "description": "",
    "category": null,
    "priority": "none",
    "size": 0.0,
  }; // TODO switch "none" to null

  final String ddb_catgegoryDefaultText = "Select A Category";
  List<String> ddb_category = [];

  void validate() {
    taskValidated = validTitle && validCategory ? true : false;
  }

  @override
  void initState() {
    super.initState();
    ddb_priority_value = projectPriorities.keys.first;
    ddb_category_value = ddb_catgegoryDefaultText;

    ddb_category.add(ddb_catgegoryDefaultText);
    ddb_category.addAll(projectCategories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.bg,
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // add a title
          Padding(
            padding: const EdgeInsets.all(10),
            child: Focus(
              onFocusChange: (_) => setState(() {}), // updates the focus colors
              child: TextField(
                focusNode: titleFocusNode,
                decoration: InputDecoration(
                  enabledBorder: enabledBorder(),
                  focusedBorder: focusedBorder(),
                  hintText: "A unique title for your project",
                  hintStyle: TextStyle(color: Pallete.text, fontStyle: FontStyle.italic),
                  labelText: "Title",
                  labelStyle: TextStyle(color: titleFocusNode.hasFocus ? Pallete.primary : Pallete.text),
                ),
                style: TextStyle(color: Pallete.text),
                cursorColor: Pallete.primary,
                onChanged: (value) {
                  setState(() {
                    validTitle = value.length >= 2;
                    newTask["title"] = value;
                    validate();
                  });
                },
              ),
            ),
          ),

          // add a description
          Padding(
            padding: const EdgeInsets.all(10),
            child: Focus(
              onFocusChange: (_) => setState(() {}),
              child: TextField(
                focusNode: descriptionFocusNode,
                controller: descriptionController,
                decoration: InputDecoration(
                  enabledBorder: enabledBorder(),
                  focusedBorder: focusedBorder(),
                  hintText: "Describe your project here",
                  hintStyle: TextStyle(color: Pallete.text, fontStyle: FontStyle.italic),
                  labelText: "Description",
                  labelStyle: TextStyle(color: descriptionFocusNode.hasFocus ? Pallete.primary : Pallete.text),
                  helperText: validTitle && descriptionController.text.isEmpty ? "Try to add a description" : null,
                  helperStyle: const TextStyle(color: Colors.red),
                ),
                style: TextStyle(color: Pallete.text),
                cursorColor: Pallete.primary,
                onChanged: (value) {
                  setState(() {
                    newTask["description"] = value;
                    validate();
                  });
                },
              ),
            ),
          ),
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
                      dropdownColor: Pallete.topbox,
                      value: ddb_category_value,
                      items: ddb_category.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: AdaptiveText(
                              value,
                              fontStyle: value == ddb_catgegoryDefaultText ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          newTask["category"] = ddb_category_value = value!;
                          validCategory = value != ddb_catgegoryDefaultText;
                          validate();
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
                      value: ddb_priority_value,
                      items: projectPriorities.keys.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Row(
                            children: [
                              Container(width: 30, height: 30, decoration: BoxDecoration(color: projectPriorities[value], shape: BoxShape.circle)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: AdaptiveText(value),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          newTask["priority"] = ddb_priority_value = value!;
                          validate();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          AdaptiveText("Project Size: "),
          ProjectSizeSlider(
            onChanged: (value) {
              newTask["size"] = value.toInt();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (taskValidated) {
            newTask["timeCreated"] = DateTime.now().toString();

            setState(() {
              projectsDataContent!["projects"].add(newTask); //! add deepcopy if duplication happens
              LoadingScreen.show(context, "Saving Task");
              saveFile(projectsFileData!.id!, jsonEncode(projectsDataContent)).then((value) {
                LoadingScreen.hide(context);
                Navigator.of(context).pop(true);
              });
            });
          }
        },
        backgroundColor: taskValidated ? Colors.green : Colors.red,
        child: const Icon(Icons.check),
      ),
    );
  }
}
