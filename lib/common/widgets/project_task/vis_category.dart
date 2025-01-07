import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/category.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_button_info_dialog.dart';
import 'package:keeper_of_projects/typedef.dart';

class VisCategory extends StatefulWidget {
  final Map data;
  final OnUpdated onUpdated;
  const VisCategory({
    super.key,
    required this.data,
    required this.onUpdated,
  });

  @override
  State<VisCategory> createState() => _VisCategoryState();
}

class _VisCategoryState extends State<VisCategory> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: checkCategoryValidity(widget.data["category"])
            ? ElevatedButton(
                onPressed: () {
                  showInfoDialog(
                    context,
                    "Project Category: The set category for this project. Categories are filterable in the project menu and tell more about a specific project.",
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.bg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Palette.text),
                  ),
                ),
                child: AdaptiveText("category: ${widget.data["category"]}"),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Palette.text),
                  ),
                ),
                onPressed: () async {
                  if (await showConfirmDialog(context, "Add '${widget.data["category"]}' to categories?")) {
                    setState(() {
                      String category = widget.data["category"];
                      categoryDataContent!.add(category);
                      categoryFilter[category] = true;
                      categoryDataNeedSync = true;
                      fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
                      widget.onUpdated();
                    });
                  }
                },
                child: AdaptiveText("Unknown Category: ${widget.data["category"]}"),
              ),
      ),
    );
  }
}
