import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/common/functions/category.dart';
import 'package:keeper_of_projects/common/pages/category_editor/widgets/add_category_dialog.dart';
import 'package:keeper_of_projects/common/pages/category_editor/widgets/edit_category_dialog.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/data.dart';

class CategoryEditorPage extends StatefulWidget {
  final List<String>? categories;
  const CategoryEditorPage({super.key, this.categories});

  @override
  State<CategoryEditorPage> createState() => _CategoryEditorPageState();
}

class _CategoryEditorPageState extends State<CategoryEditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        backgroundColor: Palette.primary,
        title: const Text("Edit Categories"),
      ),
      body: ListView.builder(
        itemCount: categoryDataContent!.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 5,
            color: Palette.box1,
            child: ListTile(
              title: AdaptiveText(categoryDataContent![index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      await editCategoryDialog(context, categoryDataContent![index]).then(
                        (value) {
                          setState(() {});
                        },
                      );
                    },
                    icon: AdaptiveIcon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      showConfirmDialog(
                        context,
                        "delete category \"${categoryDataContent![index]}\"?",
                      ).then(
                        (value) {
                          if (value) {
                            setState(() {
                              removeCategory(categoryDataContent![index]);
                            });
                          }
                        },
                      );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await addCategoryDialog(context).then(
            (value) {
              setState(() {});
            },
          );
        },
        backgroundColor: Palette.primary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
