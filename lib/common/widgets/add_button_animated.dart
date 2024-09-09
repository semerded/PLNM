import 'package:flutter/material.dart';
import 'package:keeper_of_projects/backend/data.dart';
import 'package:keeper_of_projects/data.dart';

typedef TaskCreated = void Function(bool value);

class AddButtonAnimated extends StatefulWidget {
  final TaskCreated taskCreated;
  final Widget routTo;
  const AddButtonAnimated({required this.taskCreated, required this.routTo, super.key});

  @override
  State<AddButtonAnimated> createState() => _AddButtonAnimatedState();
}

class _AddButtonAnimatedState extends State<AddButtonAnimated> with SingleTickerProviderStateMixin {
  late final Animation<Offset> slideAnimation;
  late final Animation<double> scaleAnimation;
  late final Animation<double> fadeAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    slideAnimation = TweenSequence<Offset>(
      [
        TweenSequenceItem<Offset>(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0, -0.2),
            ),
            weight: 2),
        TweenSequenceItem<Offset>(
            tween: Tween<Offset>(
              begin: const Offset(0, -0.2),
              end: Offset.zero,
            ).chain(
              CurveTween(curve: Curves.linear),
            ),
            weight: 2),
        TweenSequenceItem<Offset>(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(0, -0.2),
            ),
            weight: 2),
        TweenSequenceItem<Offset>(
            tween: Tween<Offset>(
              begin: const Offset(0, -0.2),
              end: Offset.zero,
            ).chain(
              CurveTween(curve: Curves.linear),
            ),
            weight: 2),
        TweenSequenceItem<Offset>(
            tween: Tween<Offset>(
              begin: Offset.zero,
              end: Offset.zero,
            ).chain(
              CurveTween(curve: Curves.linear),
            ),
            weight: 14),
      ],
    ).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    if (projectsDataContent!["projects"].length == 0) {
      animationController.repeat();
    } else {
      animationController.reset();
      animationController.stop();
    }
    return SlideTransition(
      position: slideAnimation,
      child: FloatingActionButton(
        elevation: 5,
        backgroundColor: Palette.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<bool>(
              builder: (context) => widget.routTo,
            ),
          ).then((callback) {
            if (callback != null && callback) {
              print(callback);
              widget.taskCreated(true);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
