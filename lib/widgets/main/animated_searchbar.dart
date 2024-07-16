import 'package:flutter/material.dart';

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
      height: widget.searchBarActive ? 40 : 0,
      child: AnimatedOpacity(
        opacity: widget.searchBarActive ? 1 : 0,
        duration: Duration(milliseconds: widget.milliseconds ~/ 2),
        child: SearchBar(
          focusNode: widget.focusNode,
          controller: widget.filterBar,
          autoFocus: true,
          leading: FutureBuilder(
              future: Future.delayed(Duration(milliseconds: widget.milliseconds ~/ 2)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const Icon(Icons.search);
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
                  return const Icon(Icons.close);
                } else {
                  return Container(); 
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
