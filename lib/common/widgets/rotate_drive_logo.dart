import 'package:flutter/material.dart';

class RotateDriveLogo {
  AnimationController? rotationLogoController;
  Animation<double>? rotationAnimation;

  Animation<double> get animation {
    return rotationAnimation!;
  }

  void dispose() {
    rotationLogoController!.dispose();
  }

  RotateDriveLogo(TickerProvider vsync) {
    rotationLogoController = AnimationController(vsync: vsync, duration: const Duration(seconds: 2))..repeat();
    rotationAnimation = TweenSequence<double>(
      [
        TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: 0,
              end: 1,
            ).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
            weight: 2),
        TweenSequenceItem<double>(
            tween: Tween<double>(
              begin: 0,
              end: 0,
            ).chain(
              CurveTween(curve: Curves.linear),
            ),
            weight: 2),
      ],
    ).animate(rotationLogoController!);
  }
}
