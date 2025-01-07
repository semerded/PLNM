import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/category.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

Future<String?> editCategoryDialog(BuildContext context, String uneditedText) async {
  TextEditingController textEditingController = TextEditingController();

  bool minimumRequirements() {
    return textEditingController.text.length >= 2 && !categoryDataContent!.contains(textEditingController.text) && textEditingController.text != uneditedText;
  }

  String? editedText = uneditedText;
  textEditingController.text = uneditedText;
  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: Palette.box3,
          contentPadding: const EdgeInsets.all(16),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => setState(() {
                    String editedText = value;
                  }),
                  style: TextStyle(
                    color: textEditingController.text == uneditedText ? Palette.subtext : Palette.text,
                    fontStyle: textEditingController.text == uneditedText ? FontStyle.italic : FontStyle.normal,
                  ),
                  controller: textEditingController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: "Edit Category",
                  ),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                editedText = null;
                Navigator.pop(context);
              },
              child: const AdaptiveText("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (minimumRequirements()) {
                  editedText = textEditingController.text;
                  editCategory(editedText!, uneditedText);
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Accept",
                style: TextStyle(
                  color: minimumRequirements() ? Palette.text : Colors.red,
                ),
              ),
            )
          ],
        ),
      );
    },
  );
  return editedText;
}
