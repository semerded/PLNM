import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/functions/filter/filter_data.dart';
import 'package:keeper_of_projects/common/widgets/animated_searchbar.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/desktop/pages/projects/widgets/filter_search_bar.dart';

typedef OnUpdated = void Function();

class BigProjectView extends StatefulWidget {
  final TextEditingController filterController;
  final FocusNode searchBarFocusNode;
  final OnUpdated onUpdated;

  const BigProjectView({
    super.key,
    required this.filterController,
    required this.searchBarFocusNode,
    required this.onUpdated,
  });

  @override
  State<BigProjectView> createState() => _BigProjectViewState();
}

class _BigProjectViewState extends State<BigProjectView> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                FilterSearchBar(
                  filterController: widget.filterController,
                  searchBarFocusNode: widget.searchBarFocusNode,
                  onUpdated: () {
                    setState(() {});
                  },
                ),
                AnimatedSearchBar(
                  filterController: widget.filterController,
                  searchBarActive: searchBarActive,
                  focusNode: widget.searchBarFocusNode,
                  onUpdated: (value) => setState(() {
                    searchbarValue = value;
                  }),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: projectsContent.length,
                  itemBuilder: (context, index) {
                    Map project = projectsContent[index];
                    return Card(
                      color: Palette.box,
                      child: ListTile(
                        title: AdaptiveText(project["title"]),
                      ),
                    );
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
