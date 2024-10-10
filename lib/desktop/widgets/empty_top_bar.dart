import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

class EmptyTopBar extends StatefulWidget {
  final Widget? leading;
  final String? title;
  final List<Widget>? actions;
  const EmptyTopBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
  });

  @override
  State<EmptyTopBar> createState() => _EmptyTopBarState();
}

class _EmptyTopBarState extends State<EmptyTopBar> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Palette.box3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            if (widget.leading != null) widget.leading!,
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: AdaptiveText(
                widget.title ?? "",
                fontSize: 24,
              ),
            ),
            const Spacer(),
            if (widget.actions != null) ...widget.actions!,
          ],
        ),
      ),
    );
    ;
  }
}
