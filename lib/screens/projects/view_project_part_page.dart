import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/custom/progress_elevated_button.dart';
import 'package:keeper_of_projects/common/enum/page_callback.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/projects/widgets/project_button_info_dialog.dart';

class ProjectPartViewPage extends StatefulWidget {
  final Map part;
  const ProjectPartViewPage({super.key, required this.part});

  @override
  State<ProjectPartViewPage> createState() => _ProjectPartViewPageState();
}

class _ProjectPartViewPageState extends State<ProjectPartViewPage> {
  bool partWasUpdated = false;
  PageCallback pageCallback = PageCallback.none;
  late double partCompletion = calculateCompletion(widget.part["tasks"]);

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, partWasUpdated);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Palette.primary,
          title: Text(widget.part["title"]),
        ),
        body: Column(
          children: [
            Row(
              children: [
                //^ priority visualtisation
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        showInfoDialog(
                          context,
                          "Part prioirty: parts have different priorities. A part has a general priority while its part parts can have different priorities that are not linked to the general priority.",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: projectPriorities[widget.part["priority"]],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Palette.text),
                        ),
                      ),
                      child: Text(
                        "priority: ${widget.part["priority"]}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                //^ completion visualisation
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.part["tasks"].length == 0
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                widget.part["completed"] = !widget.part["completed"];
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.part["completed"] ? Colors.green : Palette.bg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Palette.text),
                              ),
                            ),
                            child: AdaptiveText("complete${widget.part["completed"] ? "d" : ""}"),
                          )
                        : ProgressElevatedButton(
                            onPressed: () {
                              showInfoDialog(
                                context,
                                "Part completion, This shows how much of the part parts have been completed.",
                              );
                            },
                            progress: partCompletion,
                            progressColor: Colors.green,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.bg,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Palette.text),
                              ),
                            ),
                            child: AdaptiveText("Progress: ${(partCompletion * 100).toInt()}"),
                          ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AdaptiveText(
                widget.part["description"] == "" ? "No Description" : widget.part["description"],
                fontStyle: widget.part["description"] == "" ? FontStyle.italic : null,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.part["tasks"].length,
                itemBuilder: (context, index) {
                  Map task = widget.part["tasks"][index];
                  return Card(
                    color: Palette.topbox,
                    child: ListTile(
                      title: AdaptiveText(task["title"]),
                      subtitle: AdaptiveText(task["description"]),
                      shape: Border(
                        left: BorderSide(
                          width: 10,
                          color: projectPriorities[task["priority"]],
                        ),
                      ),
                      trailing: IconButton(
                        icon: AdaptiveIcon(task["completed"] ? Icons.check_box : Icons.check_box_outline_blank),
                        onPressed: () {
                          setState(() {
                            task["completed"] = !task["completed"];
                            partCompletion = calculateCompletion(widget.part["tasks"]);

                            partWasUpdated = true;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
