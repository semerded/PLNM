import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/icon.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnUpdated = void Function(String value);

// ignore: must_be_immutable
class AnimatedSearchBar extends StatefulWidget {
  final OnUpdated onUpdated;
  final bool searchBarActive;
  int milliseconds;
  final TextEditingController filterController;
  final FocusNode? focusNode;

  AnimatedSearchBar({
    super.key,
    required this.searchBarActive,
    required this.onUpdated,
    required this.filterController,
    this.milliseconds = 300,
    this.focusNode,
  });

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
          child: TextField(
            decoration: InputDecoration(
              fillColor: Palette.topbox,
              hintText: "Search For Projects",
              hintStyle: TextStyle(
                fontStyle: FontStyle.italic,
                color: Palette.subtext,
              ),
              helperStyle: TextStyle(
                color: Palette.text,
              ),
              label: FutureBuilder(
                  future: Future.delayed(Duration(milliseconds: widget.milliseconds ~/ 2)),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return const AdaptiveIcon(Icons.search);
                    } else {
                      return Container();
                    }
                  }),
              suffixIcon: IconButton(
                onPressed: () {
                  widget.filterController.clear();
                  widget.onUpdated("");

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
            ),

            onChanged: (value) {
              widget.onUpdated(value);
            },
            focusNode: widget.focusNode,
            controller: widget.filterController,
            autofocus: false, // prevent keyboard from opening when app is opened
          ),
        ),
      ),
    );
  }
}
