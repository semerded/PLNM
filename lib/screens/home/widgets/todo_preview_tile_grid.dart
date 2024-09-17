import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/search_index_from_maplist_with_id.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/home/widgets/preview_tile.dart';
import 'package:keeper_of_projects/screens/todo/add_todo_page.dart';
import 'package:keeper_of_projects/screens/todo/todo_page.dart';
import 'package:keeper_of_projects/screens/todo/todo_view_page.dart';

typedef TodoNavigationCallback = void Function(bool value);

class TodoPreviewTileGrid extends StatefulWidget {
  final List mostProgressedTodo;
  final TodoNavigationCallback todoNavigationCallback;
  const TodoPreviewTileGrid({
    super.key,
    required this.mostProgressedTodo,
    required this.todoNavigationCallback,
  });

  @override
  State<TodoPreviewTileGrid> createState() => _TodoPreviewTileGridState();
}

class _TodoPreviewTileGridState extends State<TodoPreviewTileGrid> {
  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
        crossAxisCount: 5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: () {
          List<Widget> children = [];
          if (widget.mostProgressedTodo.isNotEmpty) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 1,
                child: PreviewTile(
                  title: widget.mostProgressedTodo[0]["title"],
                  completion: calculateCompletion(widget.mostProgressedTodo[0]["task"]),
                  navigateToOnClick: TodoViewPage(
                    index: searchIndexFromMaplist(widget.mostProgressedTodo[0], todoContent),
                    todoData: todoContent[searchIndexFromMaplist(widget.mostProgressedTodo[0], todoContent)],
                  ),
                  navigateCallback: (value) {
                    widget.todoNavigationCallback(value);
                  },
                ),
              ),
            );
          }
          if (widget.mostProgressedTodo.length > 1) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 1,
                child: PreviewTile(
                  navigateToOnClick: TodoViewPage(
                    index: searchIndexFromMaplist(widget.mostProgressedTodo[1], todoContent),
                    todoData: todoContent[searchIndexFromMaplist(widget.mostProgressedTodo[1], todoContent)],
                  ),
                  navigateCallback: (value) {
                    widget.todoNavigationCallback(value);
                  },
                  title: widget.mostProgressedTodo[1]["title"],
                  completion: calculateCompletion(widget.mostProgressedTodo[1]["task"]),
                ),
              ),
            );
          }

          if (widget.mostProgressedTodo.length < 2) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: widget.mostProgressedTodo.isEmpty ? 2 : 1,
                child: Card(
                  margin: const EdgeInsets.all(0),
                  color: Palette.box,
                  child: Center(
                    child: ListTile(
                      title: AdaptiveText("Add more tasks!"),
                      trailing: AddButtonAnimated(
                        taskCreated: (value) {
                          widget.todoNavigationCallback(value);
                        },
                        routTo: const AddTodoPage(),
                        animateWhen: widget.mostProgressedTodo.length < 2, // todo
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
                  backgroundColor: Palette.box,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) {
                        activePage = 3;
                        return const TodoPage();
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
