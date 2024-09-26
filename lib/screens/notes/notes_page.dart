import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keeper_of_projects/common/functions/main_page_pop_scope.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/bottom_navigation_bar.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/notes/add_note_page.dart';

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
                mainAxisExtent: 231,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: 30,
                (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 185,
                        child: Card(
                          color: Palette.box,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: AdaptiveText(
                              "hello" * index,
                              maxLines: 7,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ),
                      ),
                      AdaptiveText(
                        "Title",
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      AdaptiveText("date")
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavitagionBar(),
        floatingActionButton: AddButtonAnimated(taskCreated: (value) {}, routTo: AddNotePage(), animateWhen: false),
      ),
    );
  }
}
