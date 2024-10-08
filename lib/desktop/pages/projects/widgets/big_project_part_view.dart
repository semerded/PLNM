import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/content/default_file_content.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

typedef OnIndexChange = void Function(int index);

class BigProjectPartView extends StatefulWidget {
  final Map projectData;
  final int currentPartIndex;
  final OnIndexChange onIndexChange;
  const BigProjectPartView({
    super.key,
    required this.projectData,
    required this.currentPartIndex,
    required this.onIndexChange,
  });

  @override
  State<BigProjectPartView> createState() => _BigProjectPartViewState();
}

class _BigProjectPartViewState extends State<BigProjectPartView> {
  late Map currentActivePart;

  @override
  void initState() {
    super.initState();
    currentActivePart = widget.projectData["part"][widget.currentPartIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.projectData["part"].length,
              itemBuilder: (context, index) {
                Map part = widget.projectData["part"][index];
                double partCompletion = calculateCompletion(part["tasks"]);

                return Card(
                  shape: index == widget.currentPartIndex
                      ? RoundedRectangleBorder(
                          side: const BorderSide(color: Palette.secondary, width: 2.0),
                          borderRadius: BorderRadius.circular(8.0),
                        )
                      : null,
                  color: Palette.box,
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
                    onTap: () {
                      setState(() {
                        widget.onIndexChange(index);
                        currentActivePart = widget.projectData["part"][index];
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Card(
                color: Palette.bg,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Palette.secondary, width: 2.0),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListView(children: [
                  currentActivePart["tasks"].length == 0
                      ? AdaptiveText("No tasks")
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: currentActivePart["tasks"].length,
                          itemBuilder: (context, index) {
                            Map task = currentActivePart["tasks"][index];
                            return Card(
                              color: Palette.topbox,
                              child: ListTile(
                                title: AdaptiveText(task["title"]),
                                subtitle: Text(
                                  task["description"],
                                  style: TextStyle(color: Palette.subtext),
                                ),
                              ),
                            );
                          },
                        ),
                ])),
          ),
        ],
      ),
    );
  }
}
