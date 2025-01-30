import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/enum/unknown_category_resolve.dart';
import 'package:keeper_of_projects/common/functions/category.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/project_task/unknown_category_dialog.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/common/widgets/project_task/info_dialog.dart';

typedef OnUpdated = void Function(List? value);

class VisCategory extends StatefulWidget {
  final Map data;
  final String taskOrProject;
  final OnUpdated onUpdated;
  const VisCategory({
    super.key,
    required this.data,
    required this.taskOrProject,
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
        child: countMissingCategories(widget.data["category"]) == 0
            ? ElevatedButton(
                onPressed: () {
                  showInfoDialog(
                    context,
                    () {
                      if (widget.data["category"].length > 1) {
                        return "categories: ${widget.data["category"].join(", ")}";
                      } else if (widget.data["category"].length == 1) {
                        return "category: ${widget.data["category"].first}";
                      } else {
                        return "No category";
                      }
                    }(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.bg,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Palette.text),
                  ),
                ),
                child: AdaptiveText(
                  () {
                    if (widget.data["category"].length > 1) {
                      return "categories: ${widget.data["category"].join(", ")}";
                    } else if (widget.data["category"].length == 1) {
                      return "category: ${widget.data["category"]}";
                    } else {
                      return "No category";
                    }
                  }(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
                  bool categoryAdded = false;
                  bool categoryRemoved = false;
                  List removedCategories = [];
                  for (String category in widget.data["category"]) {
                    if (!categoryDataContent!.contains(category)) {
                      UnknownCategoryResolve resolve = await showUnknownCategoryDialog(context, category, widget.taskOrProject);
                      if (resolve == UnknownCategoryResolve.add) {
                        categoryAdded = true;
                        setState(() {
                          categoryDataContent!.add(category);
                          categoryFilter[category] = true;
                        });
                      } else if (resolve == UnknownCategoryResolve.remove) {
                        categoryRemoved = true;
                        removedCategories.add(category);
                      }
                    }
                  }
                  setState(() {
                    if (categoryAdded) {
                      fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
                    }

                    if (categoryRemoved) {
                      widget.onUpdated(removedCategories);
                      return;
                    }
                    widget.onUpdated(null);
                  });
                },
                child: AdaptiveText(
                  countMissingCategories(widget.data["category"]) > 1 ? "Multiple unknown categories" : "Unknown Category: ${widget.data["category"][getIndexesOfMissingCategories(widget.data["category"]).first]}",
                ),
              ),
      ),
    );
  }
}
