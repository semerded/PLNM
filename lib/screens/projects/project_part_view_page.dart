import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/projects/widgets/project_button_info_dialog.dart';

class ProjectPartViewPage extends StatefulWidget {
  final Map<String, dynamic> part;
  const ProjectPartViewPage({super.key, required this.part});

  @override
  State<ProjectPartViewPage> createState() => _ProjectPartViewPageState();
}

class _ProjectPartViewPageState extends State<ProjectPartViewPage> {
  bool partWasUpdated = false;
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, partWasUpdated);
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Pallete.bg,
        appBar: AppBar(
          backgroundColor: Pallete.primary,
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
                      style: ElevatedButton.styleFrom(backgroundColor: projectPriorities[widget.part["priority"]]),
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
                    child: ElevatedButton(
                      onPressed: () {
                        showInfoDialog(
                          context,
                          "Part completion, This shows how much of the part parts have been completed.",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Pallete.bg,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Pallete.text),
                        ),
                      ),
                      child: AdaptiveText("category: ${widget.part["category"]}"),
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
                  Map<String, dynamic> task = widget.part["tasks"][index];
                  return Card(
                    color: Pallete.topbox,
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
