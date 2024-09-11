import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';

bool filterCategory(Map data) {
  bool filteredOut = false;

  if (categoryFilter[data["category"]] != null && categoryFilter[data["category"]]!) {
    filteredOut = false;
  }

  return filteredOut;
}
