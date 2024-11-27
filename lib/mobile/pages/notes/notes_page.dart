import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/main_page_pop_scope.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/notes/add_note_page.dart';
import 'package:keeper_of_projects/mobile/widgets/bottom_navigation_bar.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return MainPagePopScope(
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Notes"),
          backgroundColor: Palette.primary,
        ),
        body: CustomScrollView(
          slivers: [
            SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 231, // fixed values
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: notesDataContent!.length,
                (context, index) {
                  Map note = notesDataContent![index];
                  return Column(
                    children: [
                      SizedBox(
                        height: 185,
                        child: Card(
                          color: Palette.box1,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: AdaptiveText(
                              note["content"],
                              maxLines: 7,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ),
                      AdaptiveText(
                        note["title"],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      AdaptiveText(note["date"])
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        floatingActionButton: AddButtonAnimated(taskCreated: (value) {}, routTo: AddNotePage(), animateWhen: false),
      ),
    );
  }
}
