import 'package:deepcopy/deepcopy.dart';
import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/tasks/add_task.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

class EditProjectPartPage extends StatefulWidget {
  final Map partData;
  const EditProjectPartPage({super.key, required this.partData,});

  @override
  State<EditProjectPartPage> createState() => _EditProjectPartPageState();
}

class _EditProjectPartPageState extends State<EditProjectPartPage> {
  Map updatedPart = {};

  @override
  void initState() {
    super.initState();
    updatedPart = Map.from(widget.partData.deepcopy());
  }
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, null);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
        ),
        body: Column(
          children: [
            TitleTextField(
              onChanged: (value) {
                updatedPart["title"] = value;
              },
              initialValue: updatedPart["title"],
            ),
            DescriptionTextField(
              onChanged: (value) {
                updatedPart["description"] = value;
              },
              initialValue: updatedPart["description"],
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
                        elevation: 15,
                        isExpanded: true,
                        dropdownColor: Palette.topbox,
                        value: updatedPart["priority"],
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
                            updatedPart["priority"] = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      addTask(context).then(
                        (value) {
                          if (value != null) {
                            setState(() {
                              updatedPart["tasks"].add(value);
                            });
                          }
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Palette.topbox,
                    ),
                    label: AdaptiveText("Add Task"),
                    icon: const Icon(
                      Icons.add,
                      color: Palette.primary,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: updatedPart["tasks"].length,
                itemBuilder: (context, index) {
                  Map task = updatedPart["tasks"][index];
                  return Card(
                    color: Palette.topbox,
                    child: ListTile(
                      title: AdaptiveText(task["title"]),
                      subtitle: AdaptiveText(task["description"]),
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
          backgroundColor: Palette.primary,
          onPressed: () {
            // projectsContent[widget.projectIndex] = Map.from(widget.projectData);

            Navigator.pop(context, updatedPart);
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
