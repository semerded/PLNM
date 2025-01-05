import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/content/default_file_content.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/main_page_pop_scope.dart';
import 'package:keeper_of_projects/common/functions/short_datetime.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/notes/add_note_page.dart';
import 'package:keeper_of_projects/mobile/pages/notes/view_note_page.dart';
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
        body: notesDataContent!.isEmpty
            ? const Center(
                child: AdaptiveText(
                "No notes yet",
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ))
            : CustomScrollView(
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<bool>(
                                builder: (context) => ViewNotePage(
                                  note: note,
                                  index: index,
                                  onUpdated: () => setState(() {}),
                                ),
                              ),
                            ).then((callback) {
                              if (callback != null && callback) {}
                            });
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 185,
                                child: Card(
                                  color: Palette.box1,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(8),
                                    title: Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: AdaptiveText(
                                        note["content"],
                                        maxLines: 7,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              AdaptiveText(
                                note["title"],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: AdaptiveIcon(
                                        Icons.add_box_outlined,
                                        size: 14,
                                      ),
                                    ),
                                    TextSpan(text: " ${shortDateTime(toMinuteFormatter.parse(note["created"]))} | "),
                                    WidgetSpan(
                                        child: AdaptiveIcon(
                                      Icons.edit_outlined,
                                      size: 14,
                                    )),
                                    TextSpan(text: " ${shortDateTime(toMinuteFormatter.parse(note["edited"]))}"),
                                  ],
                                  style: TextStyle(fontSize: 12, color: Palette.subtext),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: CustomBottomNavigationBar(),
        floatingActionButton: AddButtonAnimated(
            taskCreated: (value) {
              setState(() {});
            },
            routTo: AddNotePage(),
            animateWhen: notesDataContent!.isEmpty),
      ),
    );
  }
}
