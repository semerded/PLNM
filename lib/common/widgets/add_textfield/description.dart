import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/textfield_border.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnChanged = void Function(String value);

class DescriptionTextField extends StatefulWidget {
  final OnChanged onChanged;
  final TextEditingController? controller;
  final String hintText;
  final String? helperText;
  final String? initialValue;
  const DescriptionTextField({
    super.key,
    required this.onChanged,
    this.hintText = "A unique title for your project",
    this.helperText,
    this.controller,
    this.initialValue,
  });

  @override
  State<DescriptionTextField> createState() => _DescriptionTextFieldState();
}

class _DescriptionTextFieldState extends State<DescriptionTextField> {
  String? initialValue;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      if (widget.controller == null) {
        initialValue = widget.initialValue;
      } else {
        widget.controller!.text = widget.initialValue!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Focus(
        onFocusChange: (_) => setState(() {}),
        child: TextFormField(
          focusNode: focusNode,
          // initialValue: initialValue,
          controller: widget.controller,
          decoration: InputDecoration(
            enabledBorder: enabledBorder(),
            focusedBorder: focusedBorder(),
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Palette.text, fontStyle: FontStyle.italic),
            labelText: "Description",
            labelStyle: TextStyle(color: focusNode.hasFocus ? Palette.primary : Palette.text),
            helperText: widget.helperText,
            helperStyle: const TextStyle(color: Colors.red),
          ),
          style: TextStyle(color: Palette.text),
          cursorColor: Palette.primary,
          onChanged: (value) => widget.onChanged(value),
        ),
      ),
    );
  }
}
