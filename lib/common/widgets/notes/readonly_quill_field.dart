import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:keeper_of_projects/data.dart';

class ReadonlyQuillField extends StatefulWidget {
  final Map note;
  const ReadonlyQuillField({super.key, required this.note});

  @override
  State<ReadonlyQuillField> createState() => _ReadonlyQuillFieldState();
}

class _ReadonlyQuillFieldState extends State<ReadonlyQuillField> {
  @override
  Widget build(BuildContext context) {
    return () {
      QuillController _controller = QuillController(readOnly: true, document: Document.fromJson(widget.note["content"]), selection: const TextSelection(baseOffset: 0, extentOffset: 0));
      return QuillEditor.basic(
        controller: _controller,
        config: QuillEditorConfig(
          enableInteractiveSelection: false,
          enableSelectionToolbar: false,
          customStyleBuilder: (Attribute attribute) {
            return TextStyle(color: Palette.text, fontSize: 12);
          },
          customStyles: DefaultStyles(
              paragraph: DefaultTextBlockStyle(
            TextStyle(color: Palette.text, fontSize: 12),
            const HorizontalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            const VerticalSpacing(0, 0),
            null,
          )),
          padding: const EdgeInsets.all(8),
          readOnlyMouseCursor: SystemMouseCursors.click,
          checkBoxReadOnly: true,
        ),
      );
    }();
  }
}
