import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

void showInfoDialog(BuildContext context, String info) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Palette.box1,
        title: AdaptiveText(info),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              "Close",
              style: TextStyle(color: Palette.primary),
            ),
          )
        ],
      );
    },
  );
}
