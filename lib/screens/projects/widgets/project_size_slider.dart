import 'package:flutter/material.dart';

typedef OnChanged = void Function(double value);

// ignore: must_be_immutable
class ProjectSizeSlider extends StatefulWidget {
  final OnChanged onChanged;
  const ProjectSizeSlider({super.key, required this.onChanged});

  @override
  State<ProjectSizeSlider> createState() => _ProjectSizeSliderState();
}

class _ProjectSizeSliderState extends State<ProjectSizeSlider> {
  double sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Slider(
      value: sliderValue,
      onChanged: (value) {
        setState(() {
          sliderValue = value;
        });
        widget.onChanged(value);
      },
      min: 0,
      max: 100,
      activeColor: Colors.green,
    );
  }
}
