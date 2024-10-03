import 'dart:convert';

import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';

List searchMostProgressedProjects(int amount) {
  List sortedProjects = json.decode(json.encode(projectsDataContent!["projects"]));
  sortedProjects.sort((a, b) => (calculateProjectCompletion(a["part"]) * 100).toInt().compareTo((calculateProjectCompletion(b["part"]) * 100).toInt()));

  sortedProjects.removeWhere((a) => (calculateProjectCompletion(a["part"]) * 100).toInt() == 100);

  if (amount < sortedProjects.length) {
    sortedProjects.sublist(sortedProjects.length - amount, sortedProjects.length);
  }
  return sortedProjects.reversed.toList();
}

List searchMostProgressedTasks(int amount) {
  List sortedProjects = json.decode(json.encode(taskDataContent!["task"]));
  sortedProjects.sort((a, b) => (calculateProjectCompletion(a["subTask"]) * 100).toInt().compareTo((calculateProjectCompletion(b["subTask"]) * 100).toInt()));

  sortedProjects.removeWhere((a) => (calculateProjectCompletion(a["subTask"]) * 100).toInt() == 100);

  if (amount < sortedProjects.length) {
    sortedProjects.sublist(sortedProjects.length - amount, sortedProjects.length);
  }
  return sortedProjects.reversed.toList();
}
