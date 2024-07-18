import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/common/widgets/textfield_border.dart';
import 'package:keeper_of_projects/data.dart';

// ignore: constant_identifier_names

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  bool taskValidated = false;
  bool validTitle = false;
  bool validCategory = false;
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  final TextEditingController descriptionController = TextEditingController();

  Map<String, dynamic> newTask = {"title": null, "description": "", "category": null, "priority": "none"};

  bool validate() {
    return validTitle && validCategory ? true : false;
  }

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
          // add a title
          Padding(
            padding: const EdgeInsets.all(10),
            child: Focus(
              onFocusChange: (_) => setState(() {}), // updates the focus colors
              child: TextField(
                focusNode: titleFocusNode,
                decoration: InputDecoration(
                  enabledBorder: enabledBorder(),
                  focusedBorder: focusedBorder(),
                  hintText: "A unique title for your project",
                  hintStyle: TextStyle(color: Pallete.text, fontStyle: FontStyle.italic),
                  labelText: "Title",
                  labelStyle: TextStyle(color: titleFocusNode.hasFocus ? Pallete.primary : Pallete.text),
                ),
                style: TextStyle(color: Pallete.text),
                cursorColor: Pallete.primary,
                onChanged: (value) {
                  setState(() {
                    validTitle = value.length >= 2;
                    newTask["title"] = value;
                  });
                },
              ),
            ),
          ),

          // add a description
          Padding(
            padding: const EdgeInsets.all(10),
            child: Focus(
              onFocusChange: (_) => setState(() {}),
              child: TextField(
                focusNode: descriptionFocusNode,
                controller: descriptionController,
                decoration: InputDecoration(
                  enabledBorder: enabledBorder(),
                  focusedBorder: focusedBorder(),
                  hintText: "Describe your project here",
                  hintStyle: TextStyle(color: Pallete.text, fontStyle: FontStyle.italic),
                  labelText: "Description",
                  labelStyle: TextStyle(color: descriptionFocusNode.hasFocus ? Pallete.primary : Pallete.text),
                  helperText: validTitle && descriptionController.text.isEmpty ? "Try to add a description" : null,
                  helperStyle: const TextStyle(color: Colors.red),
                ),
                style: TextStyle(color: Pallete.text),
                cursorColor: Pallete.primary,
                onChanged: (value) {
                  setState(() {
                    newTask["description"] = value;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    color: Pallete.box,
                    child: DropdownButton<String>(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      isExpanded: true,
                      elevation: 15,
                      value: projectCategories.first,
                      items: projectCategories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: AdaptiveText(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          newTask["category"] = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    color: Pallete.box,
                    child: DropdownButton<String>(
                      padding: const EdgeInsets.only(left: 7, right: 7),
                      elevation: 15,
                      isExpanded: true,
                      
                      value: projectPriorities.keys.first,
                      items: projectPriorities.keys.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Row(
                            children: [
                              Container(width: 30, height: 30, decoration: BoxDecoration(color: projectPriorities[value], shape: BoxShape.circle)),
                              AdaptiveText(value),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          newTask["priority"] = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
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
