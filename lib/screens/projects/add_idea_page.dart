import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/backend/google_api/save_file.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';

class AddIdeaPage extends StatefulWidget {
  const AddIdeaPage({super.key});

  @override
  State<AddIdeaPage> createState() => _AddIdeaPageState();
}

class _AddIdeaPageState extends State<AddIdeaPage> {
  Map newIdea = {
    "title": null,
    "description": "",
  };
  bool validTitle = false;
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new idea"),
      ),
      body: Column(
        children: [
          TitleTextField(
            onChanged: (value) {
              setState(() {
                validTitle = value.length >= 2;
                newIdea["title"] = value;
              });
            },
            hintText: "What is your idea",
          ),
          DescriptionTextField(
            onChanged: (value) {
              newIdea["description"] = value;
            },
            hintText: "Describe your idea",
            controller: descriptionController,
            helperText: validTitle && descriptionController.text.isEmpty ? "Try to add a description" : null,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (validTitle) {
            projectsDataContent!["ideas"].add(newIdea);
            saveFile(projectsFileData!.id!, jsonEncode(projectsDataContent));
          }
          Navigator.pop(context, true);
        },
        backgroundColor: validTitle ? Colors.green : Colors.red,
        child: const Icon(Icons.save),
      ),
    );
  }
}