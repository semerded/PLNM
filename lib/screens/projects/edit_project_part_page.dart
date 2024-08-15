import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class EditProjectPartPage extends StatefulWidget {
  const EditProjectPartPage({super.key});

  @override
  State<EditProjectPartPage> createState() => _EditProjectPartPageState();
}

class _EditProjectPartPageState extends State<EditProjectPartPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Pallete.bg,
        appBar: AppBar(
          backgroundColor: Pallete.primary,
        ),
      ),
    );
  }
}
