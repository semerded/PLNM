import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';
import 'package:keeper_of_projects/typedef.dart';

class CloudActions extends StatelessWidget {
  final Widget route;
  final String label;
  final IconData icon;
  final OnUpdated onUpdated;

  const CloudActions({
    super.key,
    required this.route,
    required this.label,
    required this.icon,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => route,
              ),
            ).then((callback) => onUpdated());
          },
          label: AdaptiveText(label),
          icon: AdaptiveIcon(icon),
          style: ElevatedButton.styleFrom(backgroundColor: Palette.box2),
        ),
      ),
    );
  }
}
