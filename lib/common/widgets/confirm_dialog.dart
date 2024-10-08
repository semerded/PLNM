import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

Future<bool> showConfirmDialog(BuildContext context, String title) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Palette.box3,
        title: AdaptiveText(title),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: AdaptiveText("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text(
              "Confirm",
              style: TextStyle(color: Palette.primary),
            ),
          ),
        ],
      );
    },
  );
}
