import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';

bool filterSearchBar(Map value) {
  bool filtered = false;

  if (!value["title"].contains(searchbarValue)) {
    filtered = true;
  }
  if (settingsDataContent!["searchInDesc"] && !value["description"].contains(searchbarValue)) {
    filtered = true;
  }
  return filtered;
}
