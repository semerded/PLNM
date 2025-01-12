import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/project_task/select_priority.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/add_project_part_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/edit_project_part_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_size_slider.dart';

class ConvertIdeaIntoProjectPage extends StatefulWidget {
  final Map idea;
  final int ideaIndex;
  const ConvertIdeaIntoProjectPage({
    super.key,
    required this.idea,
    required this.ideaIndex,
  });

  @override
  State<ConvertIdeaIntoProjectPage> createState() => _ConvertIdeaIntoProjectPageState();
}

class _ConvertIdeaIntoProjectPageState extends State<ConvertIdeaIntoProjectPage> {
  bool projectValidated = false;
  bool validTitle = false;
  bool validCategory = false;
  late Map projectDataFromIdea = {};
  final String ddb_catgegoryDefaultText = "Select A Category";
  List<String> ddb_category = [];
  late String ddb_category_value;

  @override
  void initState() {
    super.initState();
    projectDataFromIdea = {
      "title": widget.idea["title"],
      "description": widget.idea["description"],
      "category": null,
      "priority": "none",
      "size": 0.0,
      "part": [],
    };
    ddb_category_value = ddb_catgegoryDefaultText;
    ddb_category.add(ddb_catgegoryDefaultText);
    ddb_category.addAll(categoryDataContent!);
    validTitle = widget.idea["title"].length >= 2;
  }

  void cancelConverting() async {
    if (await showConfirmDialog(context, "Cancel converting your idea into a project?")) {
      Navigator.pop(context, null);
    }
  }

  void validate() {
    projectValidated = validTitle && validCategory && projectDataFromIdea["part"].length >= 1;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        cancelConverting();
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          title: const Text("Convert your idea into a project"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              cancelConverting();
            },
          ),
        ),
        body: Column(
          children: [
            TitleTextField(
              onChanged: (value) {
                projectDataFromIdea["title"] = value;
              },
              initialValue: projectDataFromIdea["title"],
            ),
            DescriptionTextField(
              validTitle: validTitle,
              onChanged: (value) {
                setState(() {
                  projectDataFromIdea["description"] = value;
                });
              },
              initialValue: projectDataFromIdea["description"],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      color: Palette.box1,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        isExpanded: true,
                        elevation: 15,
                        dropdownColor: Palette.box3,
                        value: ddb_category_value,
                        items: ddb_category.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: AdaptiveText(
                                value,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            projectDataFromIdea["category"] = ddb_category_value = value!;
                            validCategory = value != ddb_catgegoryDefaultText;
                            validate();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SelectPriority(
                      initValue: projectDataFromIdea["priority"],
                      onUpdated: (value) {
                        setState(() {
                          projectDataFromIdea["priority"] = value;
                        });
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    AdaptiveText("Size: ${() {
                      if (projectDataFromIdea["size"] == 0) {
                        return projectSizeDescription[0];
                      }
                      double value = ((projectDataFromIdea["size"] - 1) / projectSizeDescriptionSubdivisionNumber) + 1;
                      return projectSizeDescription[value.toInt()];
                    }()}"),
                    ProjectSizeSlider(
                      initialValue: projectDataFromIdea["size"].toDouble(),
                      onChanged: (value) {
                        setState(() {
                          projectDataFromIdea["size"] = value.toInt();
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
                          setState(() {
                            projectDataFromIdea["part"].add(value);
                            validate();
                          });
                        }
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.box3,
                  ),
                  label: AdaptiveText("Add Project Part"),
                  icon: const Icon(
                    Icons.add,
                    color: Palette.primary,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: projectDataFromIdea["part"].length,
                itemBuilder: (context, index) {
                  Map part = projectDataFromIdea["part"][index];
                  return Card(
                    color: Palette.box3,
                    child: ListTile(
                      title: AdaptiveText(part["title"]),
                      subtitle: Text(
                        "${part["tasks"].length} • ${part["description"]}",
                        style: TextStyle(color: Palette.subtext),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<Map>(
                                  builder: (context) => EditProjectPartPage(
                                    partData: part,
                                  ),
                                ),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    projectDataFromIdea["part"][index] = value;
                                    validate();
                                  });
                                }
                              });
                            },
                            icon: AdaptiveIcon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                projectDataFromIdea["part"].removeAt(index);
                              });
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                            ),
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
          backgroundColor: Palette.primary,
          onPressed: () {
            if (projectValidated) {
              DateTime now = DateTime.now();
              projectDataFromIdea["timeCreated"] = DateTime(now.year, now.month, now.day, now.hour, now.minute, now.second).toString();
              projectDataFromIdea["size"] = projectDataFromIdea["size"].toInt();
              ideasContent.removeAt(widget.ideaIndex);
              Navigator.pop(context, projectDataFromIdea);
            }
          },
          child: const Icon(Icons.lightbulb),
        ),
      ),
    );
  }
}
