import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnUpdated = void Function(String value);

// ignore: must_be_immutable
class AnimatedSearchBar extends StatefulWidget {
  final OnUpdated onUpdated;
  final bool searchBarActive;
  int milliseconds;
  Color? backgroundColor;
  final TextEditingController filterController;
  final FocusNode? focusNode;

  AnimatedSearchBar({
    super.key,
    required this.searchBarActive,
    required this.onUpdated,
    required this.filterController,
    this.backgroundColor,
    this.milliseconds = 300,
    this.focusNode,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  OutlineInputBorder _border() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: AnimatedContainer(
        duration: Duration(milliseconds: widget.milliseconds),
        height: widget.searchBarActive ? 60 : 0,
        child: AnimatedOpacity(
          opacity: widget.searchBarActive ? 1 : 0,
          duration: Duration(milliseconds: widget.milliseconds ~/ 2),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              style: TextStyle(color: Palette.text),
              decoration: InputDecoration(
                enabledBorder: _border(),
                focusedBorder: _border(),
                fillColor: widget.backgroundColor ?? Palette.box3,
                filled: true,
                hintText: "Search For Projects",
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Palette.subtext,
                ),
                helperStyle: TextStyle(
                  color: Palette.text,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: AdaptiveIcon(Icons.search),
                suffixIcon: IconButton(
                  icon: AdaptiveIcon(Icons.close),
                  onPressed: () {
                    widget.filterController.clear();
                    widget.onUpdated("");
                  },
                ),

                // label: FutureBuilder(
                //     future: Future.delayed(Duration(milliseconds: widget.milliseconds ~/ 2)),
                //     builder: (context, snapshot) {
                //       if (snapshot.connectionState == ConnectionState.done) {
                //         return AdaptiveIcon(Icons.search);
                //       } else {
                //         return Container();
                //       }
                //     }),
                // suffixIcon: IconButton(
                //   onPressed: () {
                //     widget.filterController.clear();
                //     widget.onUpdated("");
                //   },
                //   icon: FutureBuilder(
                //       future: Future.delayed(Duration(milliseconds: widget.milliseconds ~/ 2)),
                //       builder: (context, snapshot) {
                //         if (snapshot.connectionState == ConnectionState.done) {
                //           return AdaptiveIcon(Icons.close);
                //         } else {
                //           return Container();
                //         }
                //       }),
                // ),
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
      ),
    );
  }
}
