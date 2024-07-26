import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

class ProjectViewPage extends StatefulWidget {
  final Map<String, dynamic> projectData;
  const ProjectViewPage({required this.projectData, super.key});

  @override
  State<ProjectViewPage> createState() => _ProjectViewPageState();
}

class _ProjectViewPageState extends State<ProjectViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.projectData["title"]),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AdaptiveText(
              widget.projectData["description"] == "" ? "No Description" : widget.projectData["description"],
              fontStyle: widget.projectData["description"] == "" ? FontStyle.italic : null,
            ),
          )
        ],
      ),
    );
  }
}
