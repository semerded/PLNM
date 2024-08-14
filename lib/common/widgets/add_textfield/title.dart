import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/textfield_border.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnChanged = void Function(String value);

class TitleTextField extends StatefulWidget {
  final OnChanged onChanged;
  final String hintText;
  final String? initialValue;
  const TitleTextField({
    super.key,
    required this.onChanged,
    this.hintText = "A unique title for your project",
    this.initialValue,
  });

  @override
  State<TitleTextField> createState() => _TitleTextFieldState();
}

class _TitleTextFieldState extends State<TitleTextField> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Focus(
        onFocusChange: (_) => setState(() {}), // updates the focus colors
        child: TextFormField(
          autofocus: true,
          focusNode: focusNode,
          initialValue: widget.initialValue,
          decoration: InputDecoration(
            enabledBorder: enabledBorder(),
            focusedBorder: focusedBorder(),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Pallete.text, fontStyle: FontStyle.italic),
            labelText: "Title",
            labelStyle: TextStyle(color: focusNode.hasFocus ? Pallete.primary : Pallete.text),
          ),
          style: TextStyle(color: Pallete.text),
          cursorColor: Pallete.primary,
          onChanged: (value) => widget.onChanged(value),
        ),
      ),
    );
  }
}
