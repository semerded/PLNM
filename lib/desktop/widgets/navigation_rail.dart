import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/home/home_page.dart';
import 'package:keeper_of_projects/desktop/pages/notes/notes_page.dart';
import 'package:keeper_of_projects/desktop/pages/projects/project_page.dart';
import 'package:keeper_of_projects/desktop/pages/routines/routines_page.dart';
import 'package:keeper_of_projects/desktop/pages/tasks/task_page.dart';

class CustomNavigationRail extends StatefulWidget {
  final Widget? leading;
  const CustomNavigationRail({super.key, this.leading});

  @override
  State<CustomNavigationRail> createState() => _CustomNavigationRailState();
}

class _CustomNavigationRailState extends State<CustomNavigationRail> {
  final List navigationRailListing = [
    const HomePage(),
    const NotesPage(),
    const RoutinesPage(),
    const TaskPage(),
    const ProjectPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: NavigationRail(
        backgroundColor: Palette.topbox,
        labelType: NavigationRailLabelType.all,
        indicatorColor: Palette.primary,
        destinations: <NavigationRailDestination>[
          NavigationRailDestination(
            icon: AdaptiveIcon(Icons.home_outlined),
            selectedIcon: AdaptiveIcon(Icons.home),
            label: const AdaptiveText('Home'),
          ),
          NavigationRailDestination(
            icon: AdaptiveIcon(Icons.book_outlined),
            selectedIcon: AdaptiveIcon(Icons.book),
            label: const AdaptiveText('Notes'),
          ),
          NavigationRailDestination(
            icon: AdaptiveIcon(Icons.punch_clock_outlined),
            selectedIcon: AdaptiveIcon(Icons.punch_clock_rounded),
            label: const AdaptiveText('Routines'),
          ),
          NavigationRailDestination(
            icon: Badge(
              label: Text(taskContent.length.toString()),
              child: AdaptiveIcon(Icons.task_outlined),
            ),
            selectedIcon: Badge(
              label: Text(taskContent.length.toString()),
              child: AdaptiveIcon(Icons.task),
            ),
            label: const AdaptiveText('Tasks'),
          ),
          NavigationRailDestination(
            icon: Badge(
              label: Text(projectsContent.length.toString()),
              child: AdaptiveIcon(Icons.table_chart_outlined),
            ),
            selectedIcon: Badge(
              label: Text(projectsContent.length.toString()),
              child: AdaptiveIcon(Icons.table_chart),
            ),
            label: const AdaptiveText('Projects'),
          ),
        ],
        selectedIndex: activePage,
        leading: widget.leading,
        onDestinationSelected: (int index) {
          if (activePage != index) {
            setState(() {
              activePage = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute<bool>(
                builder: (context) => navigationRailListing[index],
              ),
            ).then((callback) {
              if (callback != null && callback) {}
            });
          }
        },
      ),
    );
  }
}
