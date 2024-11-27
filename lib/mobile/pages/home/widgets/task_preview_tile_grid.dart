import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/search_index_from_maplist_with_id.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/tasks/task_page.dart';
import 'package:keeper_of_projects/mobile/pages/home/widgets/task_preview_tile.dart';
import 'package:keeper_of_projects/mobile/pages/tasks/add_task_page.dart';
import 'package:keeper_of_projects/mobile/pages/tasks/task_view_page.dart';

typedef TaskNavigationCallback = void Function(bool value);

class TaskPreviewTileGrid extends StatefulWidget {
  final List mostProgressedTask;
  final TaskNavigationCallback taskNavigationCallback;
  const TaskPreviewTileGrid({
    super.key,
    required this.mostProgressedTask,
    required this.taskNavigationCallback,
  });

  @override
  State<TaskPreviewTileGrid> createState() => _TaskPreviewTileGridState();
}

class _TaskPreviewTileGridState extends State<TaskPreviewTileGrid> {
  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
        crossAxisCount: 5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: () {
          List<Widget> children = [];
          if (widget.mostProgressedTask.isNotEmpty) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 1,
                child: PreviewTile(
                  contentPool: taskContent,
                  id: widget.mostProgressedTask[0]["id"],
                  title: widget.mostProgressedTask[0]["title"],
                  completion: calculateCompletion(widget.mostProgressedTask[0]["subTask"]),
                  priority: widget.mostProgressedTask[0]["priority"],
                  navigateToOnClick: TaskViewPage(
                    index: searchIndexFromMaplist(widget.mostProgressedTask[0], taskContent),
                    taskData: taskContent[searchIndexFromMaplist(widget.mostProgressedTask[0], taskContent)],
                  ),
                  navigateCallback: (value) {
                    widget.taskNavigationCallback(value);
                  },
                ),
              ),
            );
          }
          if (widget.mostProgressedTask.length > 1) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 1,
                child: PreviewTile(
                  contentPool: taskContent,
                  id: widget.mostProgressedTask[1]["id"],
                  navigateToOnClick: TaskViewPage(
                    index: searchIndexFromMaplist(widget.mostProgressedTask[1], taskContent),
                    taskData: taskContent[searchIndexFromMaplist(widget.mostProgressedTask[1], taskContent)],
                  ),
                  navigateCallback: (value) {
                    widget.taskNavigationCallback(value);
                  },
                  title: widget.mostProgressedTask[1]["title"],
                  completion: calculateCompletion(widget.mostProgressedTask[1]["subTask"]),
                  priority: widget.mostProgressedTask[1]["priority"],
                ),
              ),
            );
          }

          if (widget.mostProgressedTask.length < 2) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: widget.mostProgressedTask.isEmpty ? 2 : 1,
                child: Card(
                  margin: const EdgeInsets.all(0),
                  color: Palette.box1,
                  child: Center(
                    child: ListTile(
                      title: AdaptiveText("Add more tasks!"),
                      trailing: AddButtonAnimated(
                        heroTag: "task_",
                        taskCreated: (value) {
                          widget.taskNavigationCallback(value);
                        },
                        routTo: const AddTaskPage(),
                        animateWhen: widget.mostProgressedTask.length < 2, // task
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          children.add(
            StaggeredGridTile.count(
              crossAxisCellCount: 1,
              mainAxisCellCount: 2,
              child: IconButton(
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Palette.box1,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) {
                        activePage = 3;
                        return const TaskPage();
                      },
                    ),
                  ).then((value) {
                    setState(() {});
                  });
                },
                icon: AdaptiveIcon(Icons.arrow_forward_ios),
              ),
            ),
          );

          return children;
        }());
  }
}
