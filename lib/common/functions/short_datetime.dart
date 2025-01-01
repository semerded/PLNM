import 'package:intl/intl.dart';

String shortDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration diff = now.difference(dateTime);
  DateFormat yearFormat = DateFormat('dd-MM-yyyy');
  DateFormat dateFormat = DateFormat('dd-MM');
  DateFormat timeFormat = DateFormat('HH:mm');
  if (now.year != dateTime.year) {
    return yearFormat.format(dateTime);
  }
  if (diff.inDays > 0) {
    return dateFormat.format(dateTime);
  }
  return timeFormat.format(dateTime);
}
