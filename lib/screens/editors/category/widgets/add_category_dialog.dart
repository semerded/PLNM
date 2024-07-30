import 'package:flutter/material.dart';
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
          backgroundColor: Pallete.topbox,
          contentPadding: const EdgeInsets.all(16),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(color: Pallete.text),
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
                      color: Pallete.subtext,
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
                  projectCategories.add(textEditingController.text);
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Accept",
                style: TextStyle(
                  color: minimumtRequirementsMet ? Pallete.text : Colors.red,
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}
