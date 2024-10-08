import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

bool minimumtRequirementsMet = false;

void checkMinimumRequirements(String text, int minChars) {
  minimumtRequirementsMet = text.length >= minChars;
}

Future<void> addCategoryDialog(BuildContext context) async {
  TextEditingController textEditingController = TextEditingController();
  checkMinimumRequirements(textEditingController.text, 2);

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
                  style: TextStyle(color: Palette.text),
                  controller: textEditingController,
                  onChanged: (value) => setState(
                    () {
                      checkMinimumRequirements(textEditingController.text, 2);
                    },
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Add Category",
                    hintText: "Garage Projects",
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Palette.subtext,
                    ),
                  ),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: AdaptiveText("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (minimumtRequirementsMet) {
                  categoryDataContent!.add(textEditingController.text);
                  categoryFilter[textEditingController.text] = true;
                  categoryDataNeedSync = true;
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
}
