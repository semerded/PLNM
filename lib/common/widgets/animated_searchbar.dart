import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/data.dart';

// ignore: must_be_immutable
class AnimatedSearchBar extends StatefulWidget {
  final bool searchBarActive;
  int milliseconds;
  final filterBar = TextEditingController();
  final FocusNode? focusNode;

  AnimatedSearchBar({super.key, required this.searchBarActive, this.milliseconds = 300, this.focusNode});

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: widget.milliseconds),
      height: widget.searchBarActive ? 48 : 0,
      child: AnimatedOpacity(
        opacity: widget.searchBarActive ? 1 : 0,
        duration: Duration(milliseconds: widget.milliseconds ~/ 2),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SearchBar(
            backgroundColor: WidgetStatePropertyAll(Palette.topbox),
            hintText: "Search For Projects",
            hintStyle: WidgetStatePropertyAll(
              TextStyle(
                fontStyle: FontStyle.italic,
                color: Palette.subtext,
              ),
            ),
            textStyle: WidgetStatePropertyAll(
              TextStyle(
                color: Palette.text,
              ),
            ),
            focusNode: widget.focusNode,
            controller: widget.filterBar,
            autoFocus: false, // prevent keyboard from opening when app is opened
            leading: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: widget.milliseconds ~/ 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const AdaptiveIcon(Icons.search);
                  } else {
                    return Container();
                  }
                }),
            trailing: [
              IconButton(
                onPressed: () {
                  widget.filterBar.clear();
                },
                icon: FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: widget.milliseconds ~/ 2)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return const AdaptiveIcon(Icons.close);
                      } else {
                        return Container();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
