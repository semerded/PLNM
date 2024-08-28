import 'package:keeper_of_projects/common/functions/filter/searchbar.dart';

bool itemNotFiltered(Map data) {
  bool isNotFiltered = false;

  if (filterSearchBar(data) && !isNotFiltered) {
    isNotFiltered = true;
  }

  return isNotFiltered;
}
