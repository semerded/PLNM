import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class CustomBottomNavitagionBar extends StatelessWidget {
  const CustomBottomNavitagionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Palette.topbox,
        primaryColor: Colors.red,
      ),
      child: BottomNavigationBar(
        unselectedItemColor: Palette.text,
        selectedItemColor: Palette.primary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'idk',
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
