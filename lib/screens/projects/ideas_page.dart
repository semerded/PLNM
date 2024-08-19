import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/confirm_dialog.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/screens/projects/add_idea_page.dart';

class IdeasPage extends StatefulWidget {
  const IdeasPage({super.key});

  @override
  State<IdeasPage> createState() => _IdeasPageState();
}

class _IdeasPageState extends State<IdeasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        title: Text("You have ${ideasContent.length} idea${ideasContent.length != 1 ? "s" : ""}"),
        backgroundColor: Palette.primary,
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: ideasContent.length,
          itemBuilder: (context, index) {
            Map idea = ideasContent[index];
            return Card(
              color: Palette.box,
              child: ListTile(
                title: AdaptiveText(idea["title"]),
                subtitle: AdaptiveText(idea["description"]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const AdaptiveIcon(Icons.lightbulb),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (await showConfirmDialog(context, "Delete this idea")) {
                          setState(() {
                            ideasContent.removeAt(index);
                          });
                        }
                      },
                      icon: const AdaptiveIcon(Icons.delete),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<bool>(
              builder: (context) => const AddIdeaPage(),
            ),
          ).then((callback) {
            if (callback != null && callback) {
              setState(() {});
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
