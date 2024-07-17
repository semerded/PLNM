import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:keeper_of_projects/data.dart';

// ignore: must_be_immutable
class AdaptiveText extends StatelessWidget {
  final dynamic data;
  double? fontSize;
  FontWeight? fontWeight;
  TextAlign? textAlign;
  AdaptiveText(String s, {
    super.key,
    this.data,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data!,
      textAlign: textAlign,
      style: TextStyle(
        color: Pallete.text,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
