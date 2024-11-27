import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/textfield_border.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnChanged = void Function(String value);

class DescriptionTextField extends StatefulWidget {
  final OnChanged onChanged;
  final bool validTitle;
  final String hintText;
  final String? initialValue;
  const DescriptionTextField({
    super.key,
    required this.onChanged,
    required this.validTitle,
    this.hintText = "A unique title for your project",
    this.initialValue,
  });

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  String value = "";
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      value = widget.initialValue!;
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Focus(
        onFocusChange: (_) => setState(() {}),
        child: TextFormField(
          focusNode: focusNode,
          initialValue: value,
          decoration: InputDecoration(
            enabledBorder: enabledBorder(),
            focusedBorder: focusedBorder(),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Palette.text, fontStyle: FontStyle.italic),
            labelText: "Description",
            labelStyle: TextStyle(color: focusNode.hasFocus ? Palette.primary : Palette.text),
            helperText: widget.validTitle && value.isEmpty ? "Try to add a description" : null,
            helperStyle: const TextStyle(color: Colors.red),
          ),
          style: TextStyle(color: Palette.text),
          cursorColor: Palette.primary,
          onChanged: (value) {
            widget.onChanged(value);
            this.value = value;
          },
        ),
      ),
    );
  }
}
