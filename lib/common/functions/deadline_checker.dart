String deadlineChecker(DateTime? deadline) {
  if (deadline == null) {
    return "No deadline";
  }
  DateTime currentDateTime = DateTime.now();
  Duration diff = deadline.difference(currentDateTime);

  String prefix = diff.isNegative ? "Overdue by" : "In";

  if (diff.inHours.abs() > 24) {
    return "$prefix ${diff.inDays.abs()}d & ${diff.inHours.abs() % 24}h";
  } else if (diff.inMinutes.abs() > 60) {
    return "$prefix ${diff.inHours.abs()}h & ${diff.inMinutes.abs() % 60}m";
  } else {
    return "$prefix ${diff.inMinutes.abs()}m & ${diff.inSeconds.abs() % 60}s";
  }
}

bool overdue(DateTime deadline) {
  DateTime currentDateTime = DateTime.now();
  Duration diff = deadline.difference(currentDateTime);
  return diff.isNegative;
}
