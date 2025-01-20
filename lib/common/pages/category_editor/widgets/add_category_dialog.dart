import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/category.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

Random random = Random();

Future<void> addCategoryDialog(BuildContext context) async {
  TextEditingController textEditingController = TextEditingController();
  bool minimumRequirements() {
    return textEditingController.text.length >= 2 && !categoryDataContent!.contains(textEditingController.text);
  }

  const List<String> hints = ["Garage Projects...", "Work...", "School...", "Personal Projects...", "Garden...", "Cleaning...", "Cooking...", "Shopping...", "Hobbies..."];

  String getRandomHint() {
    return hints[random.nextInt(hints.length)];
  }

  String targetHintText = getRandomHint();

  String hintText = "";
  int typingIndex = 0;
  Timer? timer;

  void startTypingAnimation(Function setState) {
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (typingIndex < targetHintText.length) {
        setState(() {
          hintText += targetHintText[typingIndex];
          typingIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  await showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        if (timer == null) {
          startTypingAnimation(setState);
        }
        return AlertDialog(
          backgroundColor: Palette.box3,
          contentPadding: const EdgeInsets.all(16),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: Palette.text,
                  ),
                  controller: textEditingController,
                  onChanged: (value) => setState(
                    () {},
                  ),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Palette.primary,
                    ),
                    labelText: "Add Category",
                    hintText: hintText,
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Palette.subtext,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Palette.primary,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                timer?.cancel();
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
                  color: minimumRequirements() ? Colors.green : Colors.red,
                ),
              ),
            )
          ],
        );
      });
    },
  ).then((_) {
    timer?.cancel();
  });
}
