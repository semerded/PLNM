import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/home/home_page.dart';
import 'package:keeper_of_projects/screens/notes/notes_page.dart';
import 'package:keeper_of_projects/screens/projects/projects_page.dart';
import 'package:keeper_of_projects/screens/routines/routines_page.dart';
import 'package:keeper_of_projects/screens/todo/todo_page.dart';

class CustomBottomNavitagionBar extends StatefulWidget {
  const CustomBottomNavitagionBar({super.key});

  @override
  State<CustomBottomNavitagionBar> createState() => _CustomBottomNavitagionBarState();
}

class _CustomBottomNavitagionBarState extends State<CustomBottomNavitagionBar> {
  final List bottomNavigationBarListing = [
    const NotesPage(),
    const RoutinesPage(),
    const HomePage(),
    const TodoPage(),
    const ProjectPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Palette.topbox,
        primaryColor: Colors.red,
      ),
      child: BottomNavigationBar(
        currentIndex: activePage,
        onTap: (int value) {
          if (activePage != value) {
            activePage = value;
            Navigator.push(
              context,
              MaterialPageRoute<bool>(
                builder: (context) => bottomNavigationBarListing[value],
              ),
            ).then((callback) {
              if (callback != null && callback) {}
            });
          }
        },
        showUnselectedLabels: true,
        unselectedItemColor: Palette.text,
        selectedItemColor: Palette.primary,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm_add_rounded),
            label: 'Routines',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task),
            label: 'Todo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_chart),
            label: 'Projects',
          ),
        ],
      ),
    );
  }
}
