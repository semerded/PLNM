import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';

bool filterSearchBar(Map data) {
  bool filteredOut = false;

  if (!data["title"].contains(searchBarValue)) {
    filteredOut = true;
  }
  if (settingsDataContent!["searchInDesc"] && data["description"].contains(searchBarValue)) {
    filteredOut = true;
  }
  return filteredOut;
}
