import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/functions/short_datetime.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/notes/readonly_quill_field.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/notes/view_note_page.dart';

class NotesGrid extends StatefulWidget {
  final List notesDataContent;
  const NotesGrid({super.key, required this.notesDataContent});

  @override
  State<NotesGrid> createState() => _NotesGridState();
}

class _NotesGridState extends State<NotesGrid> {
  @override
  Widget build(BuildContext context) {
    return widget.notesDataContent.isEmpty
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
                  childCount: widget.notesDataContent.length,
                  (context, index) {
                    Map note = widget.notesDataContent[index];
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
                                contentPadding: const EdgeInsets.all(0),
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: ReadonlyQuillField(note: note),
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
          );
  }
}
