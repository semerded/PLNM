import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SmallProjectPartView extends StatefulWidget {
  final Map projectData;
  const SmallProjectPartView({
    super.key,
    required this.projectData,
  });

  @override
  State<SmallProjectPartView> createState() => _SmallProjectPartViewState();
}

class _SmallProjectPartViewState extends State<SmallProjectPartView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.projectData["part"].length,
      itemBuilder: (context, index) {
        Map part = widget.projectData["part"][index];
        double partCompletion = calculateCompletion(part["tasks"]);

        return Card(
          color: Palette.box1,
          child: ListTile(
            title: AdaptiveText(part["title"]),
            subtitle: Text(
              part["description"],
              style: TextStyle(color: Palette.subtext),
            ),
            trailing: CircularPercentIndicator(
              radius: 24,
              animation: true,
              progressColor: Colors.green,
              center: Text(
                "${(partCompletion * 100).toInt()}%",
                style: TextStyle(color: Palette.subtext),
              ),
              percent: () {
                return partCompletion.toDouble() / 100;
              }(),
            ),
          ),
        );
      },
    );
  }
}
