import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnChanged = void Function(bool value);

class SettingsSwitch extends StatefulWidget {
  final bool initValue;
  final String title;
  final String? description;
  final OnChanged? onChanged;

  const SettingsSwitch({
    super.key,
    required this.title,
    this.description,
    required this.initValue,
    this.onChanged,
  });

  @override
  State<SettingsSwitch> createState() => SettingsSwitchState();
}

class SettingsSwitchState extends State<SettingsSwitch> {
  late bool value = widget.initValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AdaptiveText(
                widget.title,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              Switch(
                value: value,
                onChanged: (value) {
                  setState(() {
                    this.value = value;
                    widget.onChanged!(value);
                  });
                },
              ),
            ],
          ),
          if (widget.description != null)
            Text(
              widget.description!,
              style: TextStyle(
                color: Palette.subtext,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }
}
