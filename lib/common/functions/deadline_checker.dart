String deadlineChecker(DateTime? deadline) {
  if (deadline == null) {
    return "No deadline";
  }
  DateTime currentDateTime = DateTime.now();
  Duration diff = deadline.difference(currentDateTime);

  String prefix = diff.isNegative ? "Overdue by" : "In";

  if (diff.inHours > 24) {
    return "$prefix ${diff.inDays.abs()} days and ${diff.inHours % 24.abs()} hrs";
  } else {
    return "$prefix ${diff.inHours.abs()} hrs and ${diff.inMinutes % 60.abs()} min";
  }
}

bool overdue(DateTime deadline) {
  DateTime currentDateTime = DateTime.now();
  Duration diff = deadline.difference(currentDateTime);
  return diff.isNegative;
}
