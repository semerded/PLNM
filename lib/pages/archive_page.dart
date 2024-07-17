import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.bg,
      body: ListView.builder(itemBuilder: (context, index) => null),
    );
  }
}