import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/head_page_pop_scope.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/notes/add_note_page.dart';
import 'package:keeper_of_projects/mobile/pages/notes/notes_grid.dart';
import 'package:keeper_of_projects/mobile/widgets/bottom_navigation_bar.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return HeadPagePopScope(
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Notes"),
          backgroundColor: Palette.primary,
        ),
        body: NotesGrid(notesDataContent: notesDataContent!),
        floatingActionButton: AddButtonAnimated(
            taskCreated: (value) {
              setState(() {});
            },
            routTo: AddNotePage(),
            animateWhen: notesDataContent!.isEmpty),
        bottomNavigationBar: CustomBottomNavigationBar(),
      ),
    );
  }
}
