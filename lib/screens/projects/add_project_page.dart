// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/common/widgets/loading_screen.dart';
import 'package:keeper_of_projects/screens/projects/add_project_part_page.dart';
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
  final TextEditingController descriptionController = TextEditingController();
  late String ddb_priority_value;
  late String ddb_category_value;

  Map newProject = {
    "title": null,
    "description": "",
    "category": null,
    "priority": "none",
    "size": 0.0,
    "part": [],
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
    ddb_category.addAll(categoryDataContent!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.bg,
      appBar: AppBar(
        title: const Text("Create a new project"),
        backgroundColor: Pallete.primary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // add a title
          TitleTextField(
            hintText: "A unique title for your project",
            onChanged: (value) {
              setState(() {
                validTitle = value.length >= 2;
                newProject["title"] = value;
                validate();
              });
            },
          ),

          // add a description
          DescriptionTextField(
            controller: descriptionController,
            hintText: "Describe your project here",
            helperText: validTitle && descriptionController.text.isEmpty ? "Try to add a description" : null,
            onChanged: (value) {
              setState(() {
                newProject["description"] = value;
                validate();
              });
            },
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
                          newProject["category"] = ddb_category_value = value!;
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
                          newProject["priority"] = ddb_priority_value = value!;
                          validate();
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  AdaptiveText("Size: ${() {
                    if (newProject["size"] == 0) {
                      return projectSizeDescription[0];
                    }
                    double value = ((newProject["size"] - 1) / projectSizeDescriptionSubdivisionNumber) + 1;
                    return projectSizeDescription[value.toInt()];
                  }()}"),
                  ProjectSizeSlider(
                    onChanged: (value) {
                      setState(() {
                        newProject["size"] = value.toInt();
                      });
                    },
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<Map>(
                      builder: (context) => const AddProjectPartPage(),
                    ),
                  ).then(
                    (value) {
                      if (value != null) {
                        print(value);
                        setState(() {
                          newProject["part"].add(value);
                        });
                      }
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallete.topbox,
                ),
                label: AdaptiveText("Add Project Part"),
                icon: const Icon(
                  Icons.add,
                  color: Pallete.primary,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: newProject["part"].length,
              itemBuilder: (context, index) {
                Map part = newProject["part"][index];
                return Card(
                  color: Pallete.topbox,
                  child: ListTile(
                    title: AdaptiveText(part["title"]),
                    subtitle: RichText(
                      text: TextSpan(
                        text: "${part["tasks"].length} • ",
                        style: TextStyle(color: Pallete.text, fontWeight: FontWeight.bold, overflow: TextOverflow.fade),
                        children: <TextSpan>[
                          TextSpan(text: part["description"], style: TextStyle(color: Pallete.subtext)),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const AdaptiveIcon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const AdaptiveIcon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (taskValidated) {
            newProject["timeCreated"] = DateTime.now().toString();
            newProject["size"] = newProject["size"].toInt();

            setState(() {
              projectsDataContent!["projects"].add(newProject); //! add deepcopy if duplication happens
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
