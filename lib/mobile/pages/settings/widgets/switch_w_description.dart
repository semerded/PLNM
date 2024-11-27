import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

typedef OnChanged = void Function(bool value);

class SettingsSwitchWithDescription extends StatefulWidget {
  final bool initValue;
  final String title;
  final String description;
  final OnChanged? onChanged;

  const SettingsSwitchWithDescription({
    super.key,
    required this.title,
    required this.description,
    required this.initValue,
    this.onChanged,
  });

  @override
  State<SettingsSwitchWithDescription> createState() => SettingsSwitchWithDescriptionState();
}

class SettingsSwitchWithDescriptionState extends State<SettingsSwitchWithDescription> {
  late bool value = widget.initValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
      child: Card(
        elevation: 4,
        color: Palette.box1,
        child: Padding(
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
              Text(
                widget.description,
                style: TextStyle(
                  color: Palette.subtext,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
