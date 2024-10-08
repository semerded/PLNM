import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/widgets/google_pop_up_menu.dart';

typedef OnUpdated = void Function();

class TopBar extends StatefulWidget {
  final OnUpdated onUpdated;
  final String text;
  const TopBar({
    super.key,
    required this.text,
    required this.onUpdated,
  });

  @override
  State<TopBar> createState() => TopBarState();
}

class TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Palette.box3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            GooglePopUpMenu(onClose: (value) {
              if (value) {
                if (projectCategoriesNeedRebuild) {
                  projectCategoriesNeedRebuild = false;
                }
                widget.onUpdated();
              }
            }),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: AdaptiveText(
                widget.text,
                fontSize: 24,
              ),
            )
          ],
        ),
      ),
    );
  }
}
