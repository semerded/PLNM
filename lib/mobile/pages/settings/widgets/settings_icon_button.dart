import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

class SettingsIconButton extends StatefulWidget {
  final String title;
  final String? description;
  final IconData icon;
  final VoidCallback onClicked;

  const SettingsIconButton({
    super.key,
    required this.title,
    this.description,
    required this.onClicked,
    required this.icon,
  });

  @override
  State<SettingsIconButton> createState() => SettingsIconButtonState();
}

class SettingsIconButtonState extends State<SettingsIconButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdaptiveText(
                widget.title,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              IconButton(
                onPressed: () => widget.onClicked(),
                icon: AdaptiveIcon(widget.icon),
              )
            ],
          ),
          if (widget.description != null)
            Text(
              widget.description!,
              style: TextStyle(
                color: Palette.subtext,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }
}
