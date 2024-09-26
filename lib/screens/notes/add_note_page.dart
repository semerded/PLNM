import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        title: Text("Add a note"),
        backgroundColor: Palette.primary,
      ),
      body: Column(),
    );
  }
}
