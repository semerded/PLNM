import 'package:keeper_of_projects/common/functions/filter/category.dart';
import 'package:keeper_of_projects/common/functions/filter/priority.dart';
import 'package:keeper_of_projects/common/functions/filter/searchBar.dart';

bool itemFilteredOut(Map data) {
  bool isFilteredOut = false;

  if (filterSearchBar(data) && !isFilteredOut) {
    isFilteredOut = true;
  }

  if (filterPriority(data) && !isFilteredOut) {
    isFilteredOut = true;
  }

  if (filterCategory(data) && !isFilteredOut) {
    isFilteredOut = true;
  }

  return isFilteredOut;
}
