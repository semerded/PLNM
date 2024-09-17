import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/enum/page_callback.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/filter/filter.dart';
import 'package:keeper_of_projects/common/functions/filter/reset_filter.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/projects/view_project_page.dart';
import 'package:keeper_of_projects/screens/todo/todo_view_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:keeper_of_projects/common/custom/custom_one_border_painter.dart';

typedef OnUpdated = void Function();

class TodoView extends StatefulWidget {
  final List content;
  final OnUpdated onUpdated;
  final TextEditingController searchbarController;
  const TodoView({
    super.key,
    required this.content,
    required this.onUpdated,
    required this.searchbarController,
  });

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  @override
  Widget build(BuildContext context) {
    return widget.content.isEmpty
        ? Center(
            child: AdaptiveText(
              "No todos found\nCreate new todos\nor recover todos from the archive",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          )
        : () {
            List<Map> filteredList = [];
            for (Map todo in widget.content) {
              if (!itemFilteredOut(todo)) {
                filteredList.add(todo);
              }
            }
            if (filteredList.isEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdaptiveIcon(Icons.filter_alt_off),
                  AdaptiveText(
                    "You Filtered Everything!",
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      resetFilter();
                      widget.searchbarController.clear();
                      widget.onUpdated();
                    }),
                    style: ElevatedButton.styleFrom(backgroundColor: Palette.primary),
                    child: const Text(
                      "Remove All Filters",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                ],
              );
            }
            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                Map todo = filteredList[index];
                double todoCompletion = calculateCompletion(todo["task"]);
                return Card(
                  shape: Border(
                    left: BorderSide(
                      width: 10,
                      color: projectPriorities[todo["priority"]],
                    ),
                  ),
                  color: Palette.box,
                  elevation: 2,
                  child: ListTile(
                    textColor: Palette.text,
                    title: AdaptiveText(
                      todo["title"],
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    subtitle: Text(
                      todo["description"],
                      style: TextStyle(
                        color: Palette.subtext,
                        fontSize: 13,
                      ),
                    ),
                    onTap: () => setState(() {
                      Navigator.push(
                        context,
                        MaterialPageRoute<bool>(
                          builder: (context) => TodoViewPage(
                            index: index,
                            todoData: todo,
                          ),
                        ),
                      ).then((callback) {
                        if (callback != null && callback) {
                          setState(() {});
                          widget.onUpdated();
                        }
                      });
                    }),
                    trailing: CircularPercentIndicator(
                      radius: 25,
                      animation: true,
                      percent: todoCompletion,
                      progressColor: Colors.green,
                      center: AdaptiveText("${(todoCompletion * 100).toInt()}%"),
                    ),
                  ),
                );
              },
            );
          }();
  }
}
