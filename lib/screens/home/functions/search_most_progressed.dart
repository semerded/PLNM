import 'dart:convert';

import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';

List searchMostProgressedProjects(int amount) {
  List sortedProjects = json.decode(json.encode(projectsDataContent!["projects"]));
  sortedProjects.sort((a, b) => (calculateCompletion(a["part"]) * 100).toInt().compareTo((calculateCompletion(b["part"]) * 100).toInt()));
  if (amount < sortedProjects.length) {
    sortedProjects.sublist(sortedProjects.length - amount, sortedProjects.length);
  }
  return sortedProjects.reversed.toList();
}
