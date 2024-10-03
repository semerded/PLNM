import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:uuid/uuid.dart';

typedef NavigateCallback = void Function(bool value);

class ProjectPreviewTile extends StatefulWidget {
  final Widget navigateToOnClick;
  final NavigateCallback navigateCallback;
  final String title;
  final String priority;
  final double completion;
  const ProjectPreviewTile({
    super.key,
    required this.title,
    required this.completion,
    required this.priority,
    required this.navigateToOnClick,
    required this.navigateCallback,
  });

  @override
  State<ProjectPreviewTile> createState() => _PreviewTileState();
}

class _PreviewTileState extends State<ProjectPreviewTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: projectPriorities[widget.priority], width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Palette.box,
      margin: const EdgeInsets.all(0),
      child: Center(
        child: ListTile(
          title: AdaptiveText(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: CircularPercentIndicator(
            percent: widget.completion,
            radius: 24,
            center: AdaptiveText(
              "${(widget.completion * 100).toInt()}%",
            ),
            progressColor: Colors.green,
            animation: true,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => widget.navigateToOnClick,
              ),
            ).then((callback) {
              if (callback != null) {
                widget.navigateCallback(callback);
              }
            });
          },
        ),
      ),
    );
  }
}
