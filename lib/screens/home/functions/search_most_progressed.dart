import 'dart:convert';

import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';

List searchMostProgressedProjects(int amount) {
  List sortedProjects = json.decode(json.encode(projectsDataContent!["projects"]));
  sortedProjects.sort((a, b) => (calculateCompletion(a["part"]) * 100).toInt().compareTo((calculateCompletion(b["part"]) * 100).toInt()));

  sortedProjects.removeWhere((a) => (calculateCompletion(a["part"]) * 100).toInt() == 100);

  if (amount < sortedProjects.length) {
    sortedProjects.sublist(sortedProjects.length - amount, sortedProjects.length);
  }
  return sortedProjects.reversed.toList();
}

List searchMostProgressedTasks(int amount) {
  List sortedProjects = json.decode(json.encode(todoDataContent!["todo"]));
  sortedProjects.sort((a, b) => (calculateCompletion(a["task"]) * 100).toInt().compareTo((calculateCompletion(b["task"]) * 100).toInt()));

  sortedProjects.removeWhere((a) => (calculateCompletion(a["task"]) * 100).toInt() == 100);

  if (amount < sortedProjects.length) {
    sortedProjects.sublist(sortedProjects.length - amount, sortedProjects.length);
  }
  return sortedProjects.reversed.toList();
}
