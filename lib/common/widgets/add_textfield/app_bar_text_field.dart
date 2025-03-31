import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/typedef.dart';

class AppBarTextField extends StatefulWidget {
  final VoidCallback onTap;
  final OnUpdatedS onChanged;
  final String hintText;
  final String? initialValue;
  final bool autoFocus;
  final FocusNode focusNode;
  const AppBarTextField({
    super.key,
    required this.onChanged,
    required this.onTap,
    required this.focusNode,
    this.hintText = "A unique title...",
    this.initialValue,
    this.autoFocus = true,
  });

  @override
  State<AppBarTextField> createState() => _AppBarTextFieldState();
}

class _AppBarTextFieldState extends State<AppBarTextField> {
  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: true,
      onFocusChange: (_) => setState(() {}),
      child: TextFormField(
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        onTap: () => widget.onTap(),
        initialValue: widget.initialValue,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: Palette.text, fontStyle: FontStyle.italic),
        ),
        style: TextStyle(color: Palette.text),
        cursorColor: Palette.bg,
        onChanged: (value) => widget.onChanged(value),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    // widget.focusNode.dispose();
  }
}
