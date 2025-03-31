import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:path/path.dart' as path;

final QuillController quillController = () {
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
