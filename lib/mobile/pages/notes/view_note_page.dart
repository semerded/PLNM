import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/title.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/typedef.dart';

class ViewNotePage extends StatefulWidget {
  final Map note;
  final int index;
  final OnUpdated onUpdated;
  const ViewNotePage({
    super.key,
    required this.note,
    required this.index,
    required this.onUpdated,
  });

  @override
  State<ViewNotePage> createState() => ViewNotePageState();
}

class ViewNotePageState extends State<ViewNotePage> {
  late Map updatedNote;
  Timer? debounce;

  @override
  void initState() {
    super.initState();

    updatedNote = Map.from(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        title: const Text("Add a note"),
        backgroundColor: Palette.primary,
        actions: [
          IconButton(
              onPressed: () {
                showConfirmDialog(context, "Are you sure you wan't to delete this note?").then((delete) {
                  if (delete) {
                    debounce?.cancel();
                    notesDataContent!.removeAt(widget.index);
                    fileSyncSystem.syncFile(notesFileData!, jsonEncode(notesDataContent));
                    widget.onUpdated();
                    Navigator.of(context).pop(true);
                  }
                });
              },
              icon: const Icon(
                Icons.delete_forever,
              ))
        ],
      ),
      body: Column(
        children: [
          TitleTextField(
            autoFocus: false,
            initialValue: widget.note["title"],
            hintText: "Enter a title",
            onChanged: (value) {
              updatedNote["title"] = value;
            },
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: TextEditingController(text: widget.note["content"]),
                    autofocus: true,
                    style: TextStyle(color: Palette.text),
                    onChanged: (value) {
                      updatedNote["content"] = value;
                      debounce = Timer(const Duration(seconds: 1), () {
                        notesDataContent![widget.index] = updatedNote;
                        fileSyncSystem.syncFile(notesFileData!, jsonEncode(notesDataContent));
                        widget.onUpdated();
                      });
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     if (updatedNote["title"] != "") {
      //       setState(() {
      //         notesDataContent!.add(); //! add deepcopy if duplication happens
      //         LoadingScreen.show(context, "Saving Task");
      //         fileSyncSystem.syncFile(notesFileData!, jsonEncode(notesDataContent)).then((value) {
      //           LoadingScreen.hide(context);
      //           Navigator.of(context).pop(true);
      //         });
      //       });
      //     }
      //   },
      //   backgroundColor: note["title"] != "" ? Colors.green : Colors.red,
      //   child: const Icon(Icons.check),
      // ),
    );
  }
}
