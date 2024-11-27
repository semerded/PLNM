import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/search_index_from_maplist_with_id.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

typedef NavigateCallback = void Function(bool value);

class PreviewTile extends StatefulWidget {
  final Widget navigateToOnClick;
  final NavigateCallback navigateCallback;
  final String title;
  final String priority;
  final double completion;
  final String id;
  final List contentPool;
  const PreviewTile({
    super.key,
    required this.title,
    required this.completion,
    required this.priority,
    required this.navigateToOnClick,
    required this.navigateCallback,
    required this.id,
    required this.contentPool,
  });

  @override
  State<PreviewTile> createState() => _PreviewTileState();
}

class _PreviewTileState extends State<PreviewTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: projectPriorities[widget.priority], width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: Palette.box1,
      margin: const EdgeInsets.all(0),
      child: Center(
        child: ListTile(
          title: AdaptiveText(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: widget.contentPool[searchIndexFromId(widget.id, widget.contentPool)]["subTask"].length == 0
              ? () {
                  Map content = widget.contentPool[searchIndexFromId(widget.id, widget.contentPool)];
                  return IconButton(
                    icon: AdaptiveIcon(
                      content["completed"] ? Icons.check_box : Icons.check_box_outline_blank,
                      size: 36,
                    ),
                    onPressed: () {
                      setState(() {
                        content["completed"] = !content["completed"];

                        fileSyncSystem.syncFile(taskFileData!, jsonEncode(taskDataContent));
                        widget.navigateCallback(true);
                      });
                    },
                  );
                }()
              : CircularPercentIndicator(
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
