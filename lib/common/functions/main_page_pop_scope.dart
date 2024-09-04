import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class MainPagePopScope extends StatefulWidget {
  final Widget child;
  const MainPagePopScope({super.key, required this.child});

  @override
  State<MainPagePopScope> createState() => _MainPagePopScopeState();
}

class _MainPagePopScopeState extends State<MainPagePopScope> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        if (value) {
          activePage = 2;
        }
      },
      child: widget.child,
    );
  }
}
