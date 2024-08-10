import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/projects/widgets/project_button_info_dialog.dart';

// ignore: camel_case_types
enum _taskMenu {
  edit,
  completeAll,
  archive,
  delete,
}

typedef OnSelect = void Function();

class TaskPopUpMenu extends StatefulWidget {
  final OnSelect onEdit;
  final OnSelect onCompleteAll;
  final OnSelect onArchive;
  final OnSelect onDelete;
  final bool completeAllState;
  final bool archiveState;

  const TaskPopUpMenu({
    super.key,
    required this.onEdit,
    required this.onArchive,
    required this.onCompleteAll,
    required this.onDelete,
    required this.completeAllState,
    required this.archiveState,
  });

  @override
  State<TaskPopUpMenu> createState() => _TaskPopUpMenuState();
}

class _TaskPopUpMenuState extends State<TaskPopUpMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_taskMenu>(
      color: Pallete.topbox,
      icon: const Icon(Icons.more_vert),
      popUpAnimationStyle: AnimationStyle(),
      onSelected: (_taskMenu item) {
        if (item == _taskMenu.archive) {
          if (widget.archiveState) {
            widget.onArchive();
          } else {
            showInfoDialog(context, "First complete all tasks before archiving.");
          }
        } else if (item == _taskMenu.completeAll) {
          widget.onCompleteAll();
        } else if (item == _taskMenu.delete) {
          widget.onDelete();
        } else if (item == _taskMenu.edit) {
          widget.onEdit();
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<_taskMenu>>[
        PopupMenuItem<_taskMenu>(
          value: _taskMenu.edit,
          child: ListTile(
            leading: const AdaptiveIcon(Icons.edit),
            title: AdaptiveText("Edit"),
          ),
        ),
        PopupMenuItem<_taskMenu>(
          value: _taskMenu.completeAll,
          child: ListTile(
            leading: AdaptiveIcon(widget.completeAllState ? Icons.list : Icons.checklist),
            title: AdaptiveText(widget.completeAllState ? 'Decomplete All' : 'Complete All'),
          ),
        ),
        PopupMenuItem<_taskMenu>(
          value: _taskMenu.archive,
          child: ListTile(
            leading: const AdaptiveIcon(Icons.archive),
            title: Text(
              'Archive',
              style: TextStyle(
                color: widget.archiveState ? Pallete.text : Pallete.subtext,
                fontStyle: widget.archiveState ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ),
        PopupMenuItem<_taskMenu>(
          value: _taskMenu.delete,
          child: ListTile(
            leading: const AdaptiveIcon(Icons.delete_forever),
            title: AdaptiveText('Delete'),
          ),
        ),
      ],
    );
  }
}
