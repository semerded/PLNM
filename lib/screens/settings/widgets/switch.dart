import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';

typedef OnChanged = void Function(bool value);

class SettingsSwitch extends StatefulWidget {
  final bool initValue;
  final String switchTitle;
  final OnChanged? onChanged;

  const SettingsSwitch({
    super.key,
    required this.switchTitle,
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
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AdaptiveText(widget.switchTitle),
          Switch(
              value: value,
              onChanged: (value) {
                setState(() {
                  this.value = value;
                  widget.onChanged!(value);
                });
              }),
        ],
      ),
    );
  }
}
