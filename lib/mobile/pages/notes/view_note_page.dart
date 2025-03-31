import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/quill_controller.dart';
import 'package:keeper_of_projects/common/widgets/add_textfield/app_bar_text_field.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/notes/note_text_handler.dart';
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
  final FocusNode quillFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    super.initState();

    updatedNote = Map.from(widget.note);
  }

  void unfocusOthers(FocusNode focusedNode) {
    // Unfocus any other focus nodes when one gains focus
    if (focusedNode == titleFocusNode && quillFocusNode.hasFocus) {
      quillFocusNode.unfocus();
    } else if (focusedNode == quillFocusNode && titleFocusNode.hasFocus) {
      titleFocusNode.unfocus();
    }
  }

  void setDebounce() {
    if (debounce != null) debounce!.cancel();
    debounce = Timer(const Duration(seconds: 1), () {
      notesDataContent![widget.index] = updatedNote;
      fileSyncSystem.syncFile(notesFileData!, jsonEncode(notesDataContent));
      widget.onUpdated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        backgroundColor: Palette.primary,
        title: AppBarTextField(
          onTap: () => unfocusOthers(titleFocusNode),
          focusNode: titleFocusNode,
          autoFocus: false,
          initialValue: widget.note["title"],
          hintText: "Enter a title",
          onChanged: (value) {
            setState(() {
              updatedNote["title"] = value;
              setDebounce();
            });
          },
        ),
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
          Expanded(
            child: NoteTextHandler(
              onTap: () => unfocusOthers(quillFocusNode),
              quillController: quillController,
              focusNode: quillFocusNode,
              content: List<Map<String, dynamic>>.from(widget.note["content"]),
              onTextChanged: (value) {
                DateTime now = DateTime.now();
                updatedNote["edited"] = toMinuteFormatter.format(now);
                updatedNote["content"] = value;
                setDebounce();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    quillFocusNode.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }
}
