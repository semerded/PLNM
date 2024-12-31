import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/loading_screen.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:uuid/uuid.dart';

String getInitialTitle() {
  DateTime now = DateTime.now();
  String title = "Note ${now.month}/${now.day}";
  int duplicateCounter = 0;
  for (Map note in notesDataContent!) {
    if (note["title"].contains(title)) duplicateCounter++;
  }

  return "$title ${duplicateCounter > 0 ? "(${duplicateCounter + 1})" : ""}";
}

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  Map<String, dynamic> note = {
    "title": getInitialTitle(),
    "date": () {
      DateTime now = DateTime.now();
      return DateTime(now.year, now.month).toString();
    }(),
    "content": "",
    "id": Uuid().v4(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        title: Text("Add a note"),
        backgroundColor: Palette.primary,
      ),
      body: Column(
        children: [
          TitleTextField(
            autoFocus: false,
            initialValue: getInitialTitle(),
            hintText: "Enter a title",
            onChanged: (value) {
              note["title"] = value;
            },
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    autofocus: true,
                    style: TextStyle(color: Palette.text),
                    onChanged: (value) {
                      note["content"] = value;
                    },
                    minLines: 50,
                    decoration: null,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (note["title"] != "") {
            setState(() {
              notesDataContent!.add(note); //! add deepcopy if duplication happens
              LoadingScreen.show(context, "Saving Task");
              fileSyncSystem.syncFile(notesFileData!, jsonEncode(notesDataContent)).then((value) {
                LoadingScreen.hide(context);
                Navigator.of(context).pop(true);
              });
            });
          }
        },
        backgroundColor: note["title"] != "" ? Colors.green : Colors.red,
        child: const Icon(Icons.check),
      ),
    );
  }
}
