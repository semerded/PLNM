import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnUpdated = void Function(String value);

class SelectPriority extends StatefulWidget {
  final String value;
  final OnUpdated onUpdated;
  const SelectPriority({
    super.key,
    required this.value,
    required this.onUpdated,
  });

  @override
  State<SelectPriority> createState() => _SelectPriorityState();
}

class _SelectPriorityState extends State<SelectPriority> {
  late String value;

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        color: Palette.box,
        child: DropdownButton<String>(
          padding: const EdgeInsets.only(left: 7, right: 7),
          elevation: 15,
          isExpanded: true,
          dropdownColor: Palette.topbox,
          value: value,
          items: projectPriorities.keys.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem(
              value: value,
              child: Row(
                children: [
                  Container(width: 30, height: 30, decoration: BoxDecoration(color: projectPriorities[value], shape: BoxShape.circle)),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: AdaptiveText(
                      value,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              this.value = value!;
            });
            widget.onUpdated(value!);
          },
        ),
      ),
    );
  }
}