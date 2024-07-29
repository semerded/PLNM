import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/editors/category/widgets/text_dialog.dart';

class CategoryEditorPage extends StatefulWidget {
  const CategoryEditorPage({super.key});

  @override
  State<CategoryEditorPage> createState() => _CategoryEditorPageState();
}

class _CategoryEditorPageState extends State<CategoryEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.bg,
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text("Edit Categories"),
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: projectCategories.length,
          itemBuilder: (context, index) {
            return Card(
              color: Pallete.box,
              child: ListTile(
                title: AdaptiveText(projectCategories[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const AdaptiveIcon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          projectCategories.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          setState(() {
            showTextDialog(context, "Add Category");
          });
        },
        backgroundColor: Pallete.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
