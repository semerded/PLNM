import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/functions/category.dart';
import 'package:keeper_of_projects/common/functions/deadline_checker.dart';
import 'package:keeper_of_projects/data.dart';

class CardDescription extends StatelessWidget {
  final Map data;
  const CardDescription({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          if (countMissingCategories(data["category"]) > 0)
            TextSpan(
              text: "[!category not found!] ${data["due"] == null ? '' : ' • '} ",
              style: const TextStyle(color: Colors.orange),
            ),
          if (data["due"] != null)
            TextSpan(
              text: deadlineChecker(toMinuteFormatter.parse(data["due"])),
              style: TextStyle(
                color: overdue(toMinuteFormatter.parse(data["due"])) ? Colors.red : Palette.subtext,
              ),
            ),
          TextSpan(
            text: "${data["description"].length == 0 || data["due"] == null ? '' : ' • '}${data["description"]}",
            style: TextStyle(
              color: Palette.subtext,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
