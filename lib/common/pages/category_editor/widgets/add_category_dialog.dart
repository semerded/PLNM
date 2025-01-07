import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/category.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

Future<void> addCategoryDialog(BuildContext context) async {
  TextEditingController textEditingController = TextEditingController();
  bool minimumRequirements() {
    return textEditingController.text.length >= 2 && !categoryDataContent!.contains(textEditingController.text);
  }

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
                    () {},
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
                if (minimumRequirements()) {
                  addCategory(textEditingController.text);
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
}
