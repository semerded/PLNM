import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/textfield_border.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnChanged = void Function(String value);

class TitleTextField extends StatefulWidget {
  final OnChanged onChanged;
  final FocusNode focusNode;
  final String hintText;
  const TitleTextField({
    super.key,
    required this.focusNode,
    required this.onChanged,
    this.hintText = "A unique title for your project",
  });

  @override
  State<TitleTextField> createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Focus(
        onFocusChange: (_) => setState(() {}), // updates the focus colors
        child: TextField(
          autofocus: true,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            enabledBorder: enabledBorder(),
            focusedBorder: focusedBorder(),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Pallete.text, fontStyle: FontStyle.italic),
            labelText: "Title",
            labelStyle: TextStyle(color: widget.focusNode.hasFocus ? Pallete.primary : Pallete.text),
          ),
          style: TextStyle(color: Pallete.text),
          cursorColor: Pallete.primary,
          onChanged: (value) => widget.onChanged(value),
        ),
      ),
    );
  }
}
