double calculateCompletion(List<dynamic> taskslist) {
  int length = 0;
  int completed = 0;
  for (dynamic value in taskslist) {
    length++;
    if (value["completed"]) {
      completed++;
    }
  }
  if (length != 0) {
    return completed / length;
  }
  return 0;
}
