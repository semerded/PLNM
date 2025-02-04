import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class CardGroup extends StatefulWidget {
  final List<Widget> children;
  final String? title;
  const CardGroup({super.key, required this.title, required this.children});

  @override
  State<CardGroup> createState() => _CardGroupState();
}

class _CardGroupState extends State<CardGroup> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Card(
        color: Palette.box1,
        child: Column(
          children: () {
            List<Widget> children = [];
            if (widget.title != null) {
              children.add(
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 2, bottom: 0),
                  child: Text(
                    widget.title!,
                    style: TextStyle(
                      fontSize: 20,
                      color: Palette.text,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
              children.add(Divider(
                indent: 8,
                endIndent: 8,
                color: Palette.text,
              ));
            }
            for (var child in widget.children) {
              children.add(child);
              children.add(Divider(
                color: Palette.text,
                indent: 8,
                endIndent: 8,
              ));
            }
            children.removeLast();
            return children;
          }(),
        ),
      ),
    );
  }
}
