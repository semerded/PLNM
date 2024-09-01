import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';

bool filterSearchBar(Map data) {
  bool filteredOut = false;

  if (!data["title"].contains(searchbarValue)) {
    filteredOut = true;
  }
  if (settingsDataContent!["searchInDesc"] && data["description"].contains(searchbarValue)) {
    filteredOut = true;
  }
  return filteredOut;
}
