import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/data.dart';

bool filterPriority(Map data) {
    bool filteredOut = true;

  
  if (priorityFilter[projectPriorities.keys.toList().indexOf(data["priority"])]) {
    filteredOut = false;
  }

  return filteredOut;
}