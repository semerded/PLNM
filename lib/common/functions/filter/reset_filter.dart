import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';

void resetFilter() {
  searchBarValue = "";
  searchBarActive = false;
  priorityFilter = [true, true, true, true, true];
  for (String category in categoryFilter.keys) {
    categoryFilter[category] = true;
  }
}
