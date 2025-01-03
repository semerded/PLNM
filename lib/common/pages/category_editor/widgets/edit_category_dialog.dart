import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

bool minimumtRequirementsMet = false;

void checkMinimumRequirements(String text, String uneditedText, int minChars) {
  minimumtRequirementsMet = text != uneditedText && text.length >= minChars;
}

Future<String?> editCategoryDialog(BuildContext context, String uneditedText) async {
  TextEditingController textEditingController = TextEditingController();
  textEditingController.text = uneditedText;
  checkMinimumRequirements(textEditingController.text, uneditedText, 2);
  String? editedText;
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
                    checkMinimumRequirements(textEditingController.text, uneditedText, 2);
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
              child: AdaptiveText("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (minimumtRequirementsMet) {
                  editedText = textEditingController.text;
                  categoryDataNeedSync = true;
                  categoryFilter[editedText!] = categoryFilter.remove(uneditedText)!;
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Accept",
                style: TextStyle(
                  color: minimumtRequirementsMet ? Palette.text : Colors.red,
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
