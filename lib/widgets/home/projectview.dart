import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

class ProjectView extends StatefulWidget {
  const ProjectView({super.key});

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    return projectsContent.isEmpty
        ? Center(
            child: AdaptiveText(
              "No projects found\nCreate new ideas / projects\nor recover projects from the archive",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          )
        : ListView.builder(
            itemCount: projectsContent.length,
            itemBuilder: (context, index) {
              return Card(
                color: Pallete.box,
                elevation: 2,
                child: ListTile(
                  textColor: Pallete.text,
                  title: AdaptiveText(projectsContent[index]["title"]),
                  subtitle: AdaptiveText(projectsContent[index]["description"]),
                  onTap: () => setState(() {
                    projectsContent.removeAt(index);
                  }),
                ),
              );
            },
          );
  }
}
