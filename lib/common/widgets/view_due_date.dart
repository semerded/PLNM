import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/functions/deadline_checker.dart';
import 'package:keeper_of_projects/data.dart';

class ViewDueDate extends StatefulWidget {
  final Map data;
  const ViewDueDate({
    super.key,
    required this.data,
  });

  @override
  State<ViewDueDate> createState() => _ViewDueDateState();
}

class _ViewDueDateState extends State<ViewDueDate> {
  @override
  Widget build(BuildContext context) {
    if (widget.data["due"] != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Due: ${widget.data["due"]} | ${deadlineChecker(dueDateFormater.parse(widget.data["due"]))}",
          style: TextStyle(
            color: overdue(dueDateFormater.parse(widget.data["due"])) ? Colors.red : Palette.text,
          ),
        ),
      );
    }
    return Container();
  }
}
