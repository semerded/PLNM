import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/description.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/data.dart';

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
      backgroundColor: Palette.bg,
      appBar: AppBar(
        backgroundColor: Palette.primary,
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
            validTitle: validTitle,
            onChanged: (value) {
              setState(() {
                newIdea["description"] = value;
              });
            },
            hintText: "Describe your idea",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (validTitle) {
            projectsDataContent!["ideas"].add(newIdea);
            fileSyncSystem.syncFile(projectsFileData!, jsonEncode(projectsDataContent));
          }
          Navigator.pop(context, true);
        },
        backgroundColor: validTitle ? Colors.green : Colors.red,
        child: const Icon(Icons.save),
      ),
    );
  }
}
