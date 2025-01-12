import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class SwitchDarkModeIconButton extends StatefulWidget {
  final VoidCallback onSwitch;
  const SwitchDarkModeIconButton({super.key, required this.onSwitch});

  @override
  State<SwitchDarkModeIconButton> createState() => _SwitchDarkModeIconButtonState();
}

class _SwitchDarkModeIconButtonState extends State<SwitchDarkModeIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => setState(() {
              darkMode = !darkMode;
              Palette.setDarkmode(darkMode);
              widget.onSwitch();
            }),
        icon: Icon(
          darkMode ? Icons.light_mode : Icons.dark_mode,
          color: Palette.text,
        ));
  }
}
