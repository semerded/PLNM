import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/enum/page_callback.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:deepcopy/deepcopy.dart';
import 'package:keeper_of_projects/screens/projects/add_project_part_page.dart';
import 'package:keeper_of_projects/screens/projects/edit_project_part_page.dart';
import 'package:keeper_of_projects/screens/projects/widgets/project_size_slider.dart';

class EditProjectPage extends StatefulWidget {
  final Map projectData;
  const EditProjectPage({
    super.key,
    required this.projectData,
  });

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  Map updatedProjectData = {};

  @override
  void initState() {
    super.initState();
    updatedProjectData = Map.from(widget.projectData.deepcopy());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, null);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          title: Text("Editing: ${widget.projectData["title"]}"),
        ),
        body: Column(
          children: [
            TitleTextField(
              onChanged: (value) {
                updatedProjectData["title"] = value;
              },
              initialValue: updatedProjectData["title"],
            ),
            DescriptionTextField(
              onChanged: (value) {
                updatedProjectData["description"] = value;
              },
              initialValue: updatedProjectData["description"],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      color: Palette.box,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        isExpanded: true,
                        elevation: 15,
                        dropdownColor: Palette.topbox,
                        value: updatedProjectData["category"], // check if exist
                        items: categoryDataContent?.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: AdaptiveText(value),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            updatedProjectData["category"] = value;
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
                      color: Palette.box,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        elevation: 15,
                        isExpanded: true,
                        dropdownColor: Palette.topbox,
                        value: updatedProjectData["priority"],
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
                            updatedProjectData["priority"] = value;
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
                      if (updatedProjectData["size"] == 0) {
                        return projectSizeDescription[0];
                      }
                      double value = ((updatedProjectData["size"] - 1) / projectSizeDescriptionSubdivisionNumber) + 1;
                      return projectSizeDescription[value.toInt()];
                    }()}"),
                    ProjectSizeSlider(
                      initialValue: updatedProjectData["size"].toDouble(),
                      onChanged: (value) {
                        setState(() {
                          updatedProjectData["size"] = value.toInt();
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
                            updatedProjectData["part"].add(value);
                          });
                        }
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.topbox,
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
                itemCount: updatedProjectData["part"].length,
                itemBuilder: (context, index) {
                  Map part = updatedProjectData["part"][index];
                  return Card(
                    color: Palette.topbox,
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
                                    updatedProjectData["part"][index] = value;
                                  });
                                }
                              });
                            },
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
          backgroundColor: Palette.primary,
          onPressed: () {
            Navigator.pop(context, updatedProjectData);
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}