import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:keeper_of_projects/common/functions/calculate_completion.dart';
import 'package:keeper_of_projects/common/functions/search_index_from_maplist_with_id.dart';
import 'package:keeper_of_projects/common/widgets/add_button_animated.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/mobile/pages/home/widgets/project_preview_tile.dart';
import 'package:keeper_of_projects/mobile/pages/projects/add_project_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/projects_page.dart';
import 'package:keeper_of_projects/mobile/pages/projects/view_project_page.dart';

typedef ProjectNavigationCallback = void Function(bool value);

class ProjectPreviewTileGrid extends StatefulWidget {
  final List mostProgressedProjects;
  final ProjectNavigationCallback projectNavigationCallback;
  const ProjectPreviewTileGrid({
    super.key,
    required this.mostProgressedProjects,
    required this.projectNavigationCallback,
  });

  @override
  State<ProjectPreviewTileGrid> createState() => _ProjectPreviewTileGridState();
}

class _ProjectPreviewTileGridState extends State<ProjectPreviewTileGrid> {
  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
        crossAxisCount: 5,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: () {
          List<Widget> children = [];
          if (widget.mostProgressedProjects.isNotEmpty) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 1,
                child: ProjectPreviewTile(
                  title: widget.mostProgressedProjects[0]["title"],
                  completion: calculateProjectCompletion(widget.mostProgressedProjects[0]["part"]),
                  priority: widget.mostProgressedProjects[0]["priority"],
                  navigateToOnClick: ProjectViewPage(
                    index: searchIndexFromMaplist(widget.mostProgressedProjects[0], projectsContent),
                    projectData: projectsContent[searchIndexFromMaplist(widget.mostProgressedProjects[0], projectsContent)],
                  ),
                  navigateCallback: (value) {
                    widget.projectNavigationCallback(value);
                  },
                ),
              ),
            );
          }
          if (widget.mostProgressedProjects.length > 1) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 1,
                child: ProjectPreviewTile(
                  navigateToOnClick: ProjectViewPage(index: searchIndexFromMaplist(widget.mostProgressedProjects[1], projectsContent), projectData: projectsContent[searchIndexFromMaplist(widget.mostProgressedProjects[1], projectsContent)]),
                  priority: widget.mostProgressedProjects[1]["priority"],
                  navigateCallback: (value) {
                    widget.projectNavigationCallback(value);
                  },
                  title: widget.mostProgressedProjects[1]["title"],
                  completion: calculateProjectCompletion(widget.mostProgressedProjects[1]["part"]),
                ),
              ),
            );
          }

          if (widget.mostProgressedProjects.length < 2) {
            children.add(
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: widget.mostProgressedProjects.isEmpty ? 2 : 1,
                child: Card(
                  margin: const EdgeInsets.all(0),
                  color: Palette.box,
                  child: Center(
                    child: ListTile(
                      title: AdaptiveText("Add more projects!"),
                      trailing: AddButtonAnimated(
                        heroTag: "project_",
                        taskCreated: (value) {
                          widget.projectNavigationCallback(value);
                        },
                        routTo: const AddProjectPage(),
                        animateWhen: widget.mostProgressedProjects.length < 2, // task
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
                        activePage = 4;
                        return const ProjectPage();
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
