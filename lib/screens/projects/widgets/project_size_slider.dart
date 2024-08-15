import 'package:flutter/material.dart';

typedef OnChanged = void Function(double value);

// ignore: must_be_immutable
class ProjectSizeSlider extends StatefulWidget {
  final OnChanged onChanged;
  final double? initialValue;
  const ProjectSizeSlider({super.key, required this.onChanged, this.initialValue});

  @override
  State<ProjectSizeSlider> createState() => _ProjectSizeSliderState();
}

class _ProjectSizeSliderState extends State<ProjectSizeSlider> {
  late double sliderValue;
  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue! >= 0 && widget.initialValue! <= 100) {
      sliderValue = widget.initialValue!;
    }
    else {
      sliderValue = 0.0;
    }
  }
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
