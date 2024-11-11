import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/enum/direction.dart';

Route pageSwipeRoute(Widget page, Direction direction) {
  assert(direction == Direction.left || direction == Direction.right); // direction up or down not permitted
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin;
      const Offset end = Offset.zero;
      if (direction == Direction.left) {
        begin = const Offset(1.0, 0.0);
      } else {
        begin = const Offset(-1.0, 0.0);
      }

      const Curve curve = Curves.ease;

      Animatable<Offset> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
