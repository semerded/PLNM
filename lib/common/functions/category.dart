import 'dart:convert';

import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/data.dart';

int countMissingCategories(List<dynamic> category) {
  return category.where((cat) => !categoryDataContent!.contains(cat)).length;
}

List<int> getIndexesOfMissingCategories(List<String> category) {
  return category.asMap().entries.where((entry) => entry.key >= categoryDataContent!.length || entry.value != categoryDataContent![entry.key]).map((entry) => entry.key).toList();
}

void addCategory(String category) {
  categoryDataContent!.add(category);
  categoryFilter[category] = true;
  projectCategoriesNeedRebuild = true;
  fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
}

void removeCategory(String category) {
  categoryDataContent!.remove(category);
  categoryFilter.remove(category);
  projectCategoriesNeedRebuild = true;
  fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
}

void editCategory(String category, String oldCategory) {
  categoryDataContent![categoryDataContent!.indexOf(oldCategory)] = category;
  categoryFilter[category] = categoryFilter.remove(oldCategory)!;
  projectCategoriesNeedRebuild = true;
  fileSyncSystem.syncFile(categoryFileData!, jsonEncode(categoryDataContent));
}
