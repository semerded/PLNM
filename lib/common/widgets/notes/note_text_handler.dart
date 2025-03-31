import 'dart:convert';
import 'dart:io' as io show Directory, File;

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:path/path.dart' as path;

typedef OnTextChanged = void Function(List<Map<String, dynamic>> value);

class NoteTextHandler extends StatefulWidget {
  final List<Map<String, dynamic>> content;
  final OnTextChanged onTextChanged;
  const NoteTextHandler({super.key, required this.content, required this.onTextChanged});

  @override
  State<NoteTextHandler> createState() => _NoteTextHandlerState();
}

class _NoteTextHandlerState extends State<NoteTextHandler> {
  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);

    _controller.document = Document.fromJson(widget.content);
  }

  void _onTextChanged() {
    // skip first (unnecessary) update when document is opened
    if (const DeepCollectionEquality().equals(_controller.document.toDelta().toJson(), widget.content)) return;

    widget.onTextChanged(_controller.document.toDelta().toJson());
  }

  final QuillController _controller = () {
    return QuillController.basic(
        config: QuillControllerConfig(
      clipboardConfig: QuillClipboardConfig(
        enableExternalRichPaste: true,
        onImagePaste: (imageBytes) async {
          if (kIsWeb) {
            // Dart IO is unsupported on the web.
            return null;
          }
          // Save the image somewhere and return the image URL that will be
          // stored in the Quill Delta JSON (the document).
          final newFileName = 'image-file-${DateTime.now().toIso8601String()}.png';
          final newPath = path.join(
            io.Directory.systemTemp.path,
            newFileName,
          );
          final file = await io.File(
            newPath,
          ).writeAsBytes(imageBytes, flush: true);
          return file.path;
        },
      ),
    ));
  }();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      body: SafeArea(
        child: Column(
          children: [
            QuillSimpleToolbar(
              controller: _controller,
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
                      _controller.document.insert(
                        _controller.selection.extentOffset,
                        TimeStampEmbed(
                          DateTime.now().toString(),
                        ),
                      );

                      _controller.updateSelection(
                        TextSelection.collapsed(
                          offset: _controller.selection.extentOffset + 1,
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
                        _editorFocusNode.requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: QuillEditor(
                focusNode: _editorFocusNode,
                scrollController: _editorScrollController,
                controller: _controller,
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
                  )),
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
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
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
