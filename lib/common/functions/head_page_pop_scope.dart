import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class HeadPagePopScope extends StatefulWidget {
  final Widget child;
  const HeadPagePopScope({super.key, required this.child});

  @override
  State<HeadPagePopScope> createState() => _HeadPagePopScopeState();
}

class _HeadPagePopScopeState extends State<HeadPagePopScope> {
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
