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
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.completion);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Card(
        color: Palette.box,
        margin: const EdgeInsets.all(0),
        child: ListTile(
          title: AdaptiveText(widget.title),
          trailing: CircularPercentIndicator(
            percent: widget.completion,
            radius: 20,
            progressColor: Colors.green,
            animation: true,
          ),
        ),
      ),
    );
  }
}
