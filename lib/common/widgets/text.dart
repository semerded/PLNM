import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:keeper_of_projects/data.dart';

class AdaptiveText extends StatelessWidget {
  final dynamic data;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final int? maxLines;

  const AdaptiveText(
    this.data, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.fontStyle,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data!,
      textAlign: textAlign,
      key: key,
      style: TextStyle(
        color: Palette.text,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        overflow: overflow,
      ),
      maxLines: maxLines,
    );
  }
}
