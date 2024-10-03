import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/projects/widgets/project_button_info_dialog.dart';

// ignore: camel_case_types
enum TaskOptions {
  edit,
  completeAll,
  archive,
  delete,
}

typedef OnSelect = void Function();

class TaskPopUpMenu extends StatefulWidget {
  final List<TaskOptions> enabledTasks;
  final OnSelect? onEdit;
  final OnSelect? onCompleteAll;
  final OnSelect? onArchive;
  final OnSelect? onDelete;
  final bool? completeAllState;
  final bool? archiveState;

  TaskPopUpMenu({
    super.key,
    required this.enabledTasks,
    this.onEdit,
    this.onArchive,
    this.onCompleteAll,
    this.onDelete,
    this.completeAllState,
    this.archiveState,
  }) {
    if (enabledTasks.contains(TaskOptions.archive)) {
      assert(onArchive != null && archiveState != null);
    }
    if (enabledTasks.contains(TaskOptions.completeAll)) {
      assert(onCompleteAll != null && completeAllState != null);
    }
    if (enabledTasks.contains(TaskOptions.delete)) {
      assert(onDelete != null);
    }
    if (enabledTasks.contains(TaskOptions.edit)) {
      assert(onEdit != null);
    }
  }

  @override
  State<TaskPopUpMenu> createState() => _TaskPopUpMenuState();
}

class _TaskPopUpMenuState extends State<TaskPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TaskOptions>(
      color: Palette.topbox,
      icon: const Icon(Icons.more_vert),
      popUpAnimationStyle: AnimationStyle(),
      onSelected: (TaskOptions item) {
        if (item == TaskOptions.archive) {
          if (widget.archiveState!) {
            widget.onArchive!();
          } else {
            showInfoDialog(context, "First complete all tasks before archiving.");
          }
        } else if (item == TaskOptions.completeAll) {
          widget.onCompleteAll!();
        } else if (item == TaskOptions.delete) {
          widget.onDelete!();
        } else if (item == TaskOptions.edit) {
          widget.onEdit!();
        }
      },
      itemBuilder: (BuildContext context) {
        List<PopupMenuEntry<TaskOptions>> popupMenuItems = [];
        if (widget.enabledTasks.contains(TaskOptions.edit)) {
          popupMenuItems.add(
            PopupMenuItem<TaskOptions>(
              value: TaskOptions.edit,
              child: ListTile(
                leading: AdaptiveIcon(Icons.edit),
                title: AdaptiveText("Edit"),
              ),
            ),
          );
        }
        if (widget.enabledTasks.contains(TaskOptions.completeAll)) {
          popupMenuItems.add(
            PopupMenuItem<TaskOptions>(
              value: TaskOptions.completeAll,
              child: ListTile(
                leading: AdaptiveIcon(widget.completeAllState! ? Icons.list : Icons.checklist),
                title: AdaptiveText(widget.completeAllState! ? 'Decomplete All' : 'Complete All'),
              ),
            ),
          );
        }
        if (widget.enabledTasks.contains(TaskOptions.archive)) {
          popupMenuItems.add(
            PopupMenuItem<TaskOptions>(
              value: TaskOptions.archive,
              child: ListTile(
                leading: AdaptiveIcon(Icons.archive),
                title: Text(
                  'Archive',
                  style: TextStyle(
                    color: widget.archiveState! ? Palette.text : Palette.subtext,
                    fontStyle: widget.archiveState! ? FontStyle.normal : FontStyle.italic,
                  ),
                ),
              ),
            ),
          );
        }
        if (widget.enabledTasks.contains(TaskOptions.delete)) {
          popupMenuItems.add(
            PopupMenuItem<TaskOptions>(
              value: TaskOptions.delete,
              child: ListTile(
                leading: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
                title: AdaptiveText('Delete'),
              ),
            ),
          );
        }
        return popupMenuItems;
      },
    );
  }
}
