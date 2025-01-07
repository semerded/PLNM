import 'dart:convert';

import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:uuid/uuid.dart';

bool checkCategoryValidity(String category) {
  return categoryDataContent!.contains(category);
}

void addCategory(String category) {
  categoryDataContent!.add(category);
  categoryFilter[category] = true;
  categoryDataNeedSync = true;
  projectCategoriesNeedRebuild = true;
  fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
}

void removeCategory(String category) {
  categoryDataContent!.remove(category);
  categoryFilter.remove(category);
  categoryDataNeedSync = true;
  projectCategoriesNeedRebuild = true;
  fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
}

void editCategory(String category, String oldCategory) {
  categoryDataContent![categoryDataContent!.indexOf(oldCategory)] = category;
  categoryFilter[category] = categoryFilter.remove(oldCategory)!;
  categoryDataNeedSync = true;
  projectCategoriesNeedRebuild = true;
  fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
}
