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
  final int projectIndex;
  const EditProjectPage({
    super.key,
    required this.projectData,
    required this.projectIndex,
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
        print("backup used");
        // print(widget.projectData);
        // projectsContent[widget.projectIndex] = Map.from(backupProjectData);
        Navigator.pop(context, [EditCallback.canceled, null]);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Pallete.bg,
        appBar: AppBar(
          backgroundColor: Pallete.primary,
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
                      color: Pallete.box,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        isExpanded: true,
                        elevation: 15,
                        dropdownColor: Pallete.topbox,
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
                      color: Pallete.box,
                      child: DropdownButton<String>(
                        padding: const EdgeInsets.only(left: 7, right: 7),
                        elevation: 15,
                        isExpanded: true,
                        dropdownColor: Pallete.topbox,
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
                itemCount: updatedProjectData["part"].length,
                itemBuilder: (context, index) {
                  Map part = updatedProjectData["part"][index];
                  return Card(
                    color: Pallete.topbox,
                    child: ListTile(
                      title: AdaptiveText(part["title"]),
                      subtitle: Text(
                        "${part["tasks"].length} • ${part["description"]}",
                        style: TextStyle(color: Pallete.subtext),
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
          backgroundColor: Pallete.primary,
          onPressed: () {
            // projectsContent[widget.projectIndex] = Map.from(widget.projectData);

            Navigator.pop(context, [EditCallback.edited, updatedProjectData]);
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
