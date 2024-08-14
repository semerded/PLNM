import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/enum/page_callback.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:deepcopy/deepcopy.dart';

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
  Map newProjectData = {};

  @override
  void initState() {
    super.initState();
    newProjectData = Map.from(widget.projectData.deepcopy());
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
                newProjectData["title"] = value;
              },
              initialValue: newProjectData["title"],
            ),
            DescriptionTextField(onChanged: (value) {
              newProjectData["description"] = value;
            },
            initialValue: newProjectData["description"],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Pallete.primary,
          onPressed: () {
            // projectsContent[widget.projectIndex] = Map.from(widget.projectData);

            Navigator.pop(context, [EditCallback.edited, newProjectData]);
          },
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
