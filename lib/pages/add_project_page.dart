import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/textfield_border.dart';
import 'package:keeper_of_projects/data.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  bool taskValidated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.bg,
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: enabledBorder(),
                focusedBorder: focusedBorder(),
                hintText: "A title for your project",
                hintStyle: TextStyle(color: Pallete.text),
              ),
              style: TextStyle(color: Pallete.text),
              cursorColor: Pallete.primary,
              onChanged: (value) {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: taskValidated ? Colors.green : Colors.red,
        child: const Icon(Icons.check),
      ),
    );
  }
}
