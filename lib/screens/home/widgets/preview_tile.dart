import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

class PreviewTile extends StatelessWidget {
  final String title;
  final Widget bottomWidget;
  const PreviewTile({
    super.key,
    required this.title,
    required this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        color: Palette.box,
        margin: const EdgeInsets.all(0),
        child: ListTile(
          title: AdaptiveText(title),
          subtitle: bottomWidget,
        ),
      ),
    );
  }
}
