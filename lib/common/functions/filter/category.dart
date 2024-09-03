import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';

bool filterCategory(Map data) {
  bool filteredOut = true;

  if (categoryFilter[data["category"]]!) {
    filteredOut = false;
  }

  return filteredOut;
}
