import 'package:keeper_of_projects/common/functions/filter/priority.dart';
import 'package:keeper_of_projects/common/functions/filter/searchbar.dart';

bool itemFilteredOut(Map data) {
  bool isFilteredOut = false;

  if (filterSearchBar(data) && !isFilteredOut) {
    isFilteredOut = true;
  }

  if (filterPriority(data) && !isFilteredOut) {
    isFilteredOut = true;
  }

  return isFilteredOut;
}
