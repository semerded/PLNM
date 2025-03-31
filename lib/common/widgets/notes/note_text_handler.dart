import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnTextChanged = void Function(List<Map<String, dynamic>> value);

class NoteTextHandler extends StatefulWidget {
  final List<Map<String, dynamic>> content;
  final VoidCallback onTap;
  final OnTextChanged onTextChanged;
  final FocusNode focusNode;
  final QuillController quillController;
  const NoteTextHandler({
    super.key,
    required this.content,
    required this.onTextChanged,
    required this.focusNode,
    required this.quillController,
    required this.onTap,
  });

  @override
  State<NoteTextHandler> createState() => _NoteTextHandlerState();
}

class _NoteTextHandlerState extends State<NoteTextHandler> {
  @override
  void initState() {
    super.initState();
    widget.quillController.addListener(_onTextChanged);

    widget.quillController.document = Document.fromJson(widget.content);
  }

  final ScrollController _editorScrollController = ScrollController();

  void _onTextChanged() {
    if (!widget.focusNode.hasFocus) {
      widget.onTap();
      return;
    }
    // skip first (unnecessary) update when document is opened
    if (const DeepCollectionEquality().equals(widget.quillController.document.toDelta().toJson(), widget.content)) return;

    widget.onTextChanged(widget.quillController.document.toDelta().toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: SafeArea(
        child: Column(
          children: [
            QuillSimpleToolbar(
              controller: widget.quillController,
              config: QuillSimpleToolbarConfig(
                showClipboardPaste: false,
                showFontFamily: false,
                showFontSize: false,
                showBoldButton: false,
                showItalicButton: false,
                showUnderLineButton: false,
                showStrikeThrough: false,
                showCodeBlock: false,
                showSubscript: false,
                showSuperscript: false,
                showAlignmentButtons: false,
                showInlineCode: false,
                showBackgroundColorButton: false,
                showCenterAlignment: false,
                showColorButton: false,
                showLink: false,
                showLeftAlignment: false,
                showRightAlignment: false,
                showSearchButton: false,
                customButtons: [
                  QuillToolbarCustomButtonOptions(
                    icon: const Icon(Icons.add_alarm_rounded),
                    onPressed: () {
                      widget.quillController.document.insert(
                        widget.quillController.selection.extentOffset,
                        TimeStampEmbed(
                          DateTime.now().toString(),
                        ),
                      );

                      widget.quillController.updateSelection(
                        TextSelection.collapsed(
                          offset: widget.quillController.selection.extentOffset + 1,
                        ),
                        ChangeSource.local,
                      );
                    },
                  ),
                ],
                buttonOptions: QuillSimpleToolbarButtonOptions(
                  base: QuillToolbarBaseButtonOptions(
                    afterButtonPressed: () {
                      final isDesktop = {TargetPlatform.linux, TargetPlatform.windows, TargetPlatform.macOS}.contains(defaultTargetPlatform);
                      if (isDesktop) {
                        widget.focusNode.requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: QuillEditor(
                focusNode: widget.focusNode,
                scrollController: _editorScrollController,
                controller: widget.quillController,
                config: QuillEditorConfig(
                  customStyleBuilder: (Attribute attribute) {
                    return TextStyle(color: Palette.text, fontSize: 16);
                  },
                  customStyles: DefaultStyles(
                    paragraph: DefaultTextBlockStyle(
                      TextStyle(color: Palette.text, fontSize: 16),
                      const HorizontalSpacing(0, 0),
                      const VerticalSpacing(8, 8),
                      const VerticalSpacing(0, 0),
                      null,
                    ),
                  ),
                  placeholder: 'Start writing your notes...',
                  padding: const EdgeInsets.all(16),
                  embedBuilders: [
                    TimeStampEmbedBuilder(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.quillController.removeListener(_onTextChanged);
    super.dispose();
  }
}

class TimeStampEmbed extends Embeddable {
  const TimeStampEmbed(
    String value,
  ) : super(timeStampType, value);

  static const String timeStampType = 'timeStamp';

  static TimeStampEmbed fromDocument(Document document) => TimeStampEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}

class TimeStampEmbedBuilder extends EmbedBuilder {
  @override
  String get key => 'timeStamp';

  @override
  String toPlainText(Embed node) {
    return node.value.data;
  }

  @override
  Widget build(
    BuildContext context,
    EmbedContext embedContext,
  ) {
    return Row(
      children: [
        const Icon(Icons.access_time_rounded),
        Text(embedContext.node.value.data as String),
      ],
    );
  }
}
