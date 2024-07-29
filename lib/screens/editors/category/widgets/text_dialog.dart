import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

void showTextDialog(BuildContext context, String title) {
  TextEditingController textEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Pallete.topbox,
        contentPadding: const EdgeInsets.all(16),
        content: Row(
          children: [
            Expanded(
              child: TextField(
                style: TextStyle(color: Pallete.text),
                controller: textEditingController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: title,
                  hintText: "Garage Projects",
                  hintStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Pallete.subtext
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
              projectCategories.add(textEditingController.text);
              Navigator.pop(context);
            },
            child: AdaptiveText("Accept"),
          )
        ],
      );
    },
  );
}
