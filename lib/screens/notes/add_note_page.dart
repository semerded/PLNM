import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:uuid/uuid.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  Map<String, dynamic> note = {
    "title": null,
    "date": "Note ${() {
      DateTime now = DateTime.now();
      return DateTime(now.month, now.day).toString();
    }()}",
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
            initialValue: "Note ${() {
              DateTime now = DateTime.now();
              return DateTime(now.month, now.day).toString();
            }()}",
            hintText: "Enter a title",
            onChanged: (value) {},
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: TextStyle(color: Palette.text),
                    onChanged: (value) {},
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
    );
  }
}
