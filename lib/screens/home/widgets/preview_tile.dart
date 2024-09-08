import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PreviewTile extends StatefulWidget {
  final String title;
  final double completion;
  const PreviewTile({
    super.key,
    required this.title,
    required this.completion,
  });

  @override
  State<PreviewTile> createState() => _PreviewTileState();
}

class _PreviewTileState extends State<PreviewTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Palette.box,
      margin: const EdgeInsets.all(0),
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
      ),
    );
  }
}
