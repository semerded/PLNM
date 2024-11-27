import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnClick = void Function();

class MenuItemsHeader extends StatefulWidget {
  final String text;
  final OnClick onClick;
  final bool anyFilterEnabled;

  const MenuItemsHeader({
    super.key,
    required this.text,
    required this.onClick,
    required this.anyFilterEnabled,
  });

  @override
  State<MenuItemsHeader> createState() => _MenuItemsHeaderState();
}

class _MenuItemsHeaderState extends State<MenuItemsHeader> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: AdaptiveText(widget.text),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Palette.box1),
            onPressed: () {
              widget.onClick();
            },
            child: AdaptiveText(widget.anyFilterEnabled ? "Enable All Filters" : "Disable All Filters"),
          )
        ],
      ),
    );
  }
}
