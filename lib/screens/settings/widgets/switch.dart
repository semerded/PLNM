import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnChanged = void Function(bool value);

class SettingsSwitch extends StatefulWidget {
  final bool initValue;
  final String title;
  final OnChanged? onChanged;

  const SettingsSwitch({
    super.key,
    required this.title,
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
      padding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
      child: Card(
        elevation: 4,
        color: Pallete.box,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
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
        ),
      ),
    );
  }
}
