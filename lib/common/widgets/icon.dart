import 'package:flutter/material.dart';
import 'package:keeper_of_projects/data.dart';

class AdaptiveIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final double? fill;
  final double? weight;
  final double? grade;
  final double? opticalSize;
  final Color? color;
  final List<Shadow>? shadows;
  final String? semanticLabel;
  final TextDirection? textDirection;
  final bool? applyTextScaling;
  const AdaptiveIcon(
    this.icon, {
    super.key,
    this.size,
    this.fill,
    this.weight,
    this.grade,
    this.opticalSize,
    this.color,
    this.shadows,
    this.semanticLabel,
    this.textDirection,
    this.applyTextScaling,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      applyTextScaling: applyTextScaling,
      color: color ?? Palette.text,
      fill: fill,
      grade: grade,
      key: key,
      opticalSize: opticalSize,
      semanticLabel: semanticLabel,
      shadows: shadows,
      size: size,
      textDirection: textDirection,
      weight: weight,
    );
  }
}
