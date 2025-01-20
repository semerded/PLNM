import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/enum/unknown_category_resolve.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

Future<UnknownCategoryResolve> showUnknownCategoryDialog(BuildContext context, String category, String taskOrProject) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Palette.box3,
        title: AdaptiveText("Actions for '$category': Add '$category' to categories or remove '$category' from this $taskOrProject"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, UnknownCategoryResolve.cancel),
            // ignore: prefer_const_constructors
            child: AdaptiveText("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, UnknownCategoryResolve.remove),
            child: const Text(
              "Remove",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, UnknownCategoryResolve.add),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      );
    },
  );
}
