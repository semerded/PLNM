import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/enum/conflict_type.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/switch_dark_mode_icon_button.dart';
import 'package:keeper_of_projects/data.dart';

///
/// this page is only entered when the local data is newer than the cloud data
///

const Duration darkmodeTransitionTime = Duration(milliseconds: 400);

class ConflictPage extends StatefulWidget {
  final String cloudDate;
  final String localDate;
  const ConflictPage({
    super.key,
    required this.localDate,
    required this.cloudDate,
  });

  @override
  State<ConflictPage> createState() => _ConflictPageState();
}

class _ConflictPageState extends State<ConflictPage> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Palette.bg,
        appBar: AppBar(
          backgroundColor: Colors.red,
          actions: [SwitchDarkModeIconButton(onSwitch: () => setState(() {}))],
          title: const Text("Sync Conflict"),
        ),
        body: AnimatedContainer(
          duration: darkmodeTransitionTime,
          color: Palette.bg,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AdaptiveText(
                "Oops!",
                fontSize: 48,
              ),
              AdaptiveText(
                "There seems to be a sync conflict between the local data and the cloud data...",
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  DataOptionCard(
                    name: "Local",
                    type: ConflictType.local,
                    icon: Icons.computer,
                    date: widget.localDate,
                    newer: true,
                  ),
                  DataOptionCard(
                    name: "cloud",
                    type: ConflictType.cloud,
                    icon: Icons.cloud,
                    date: widget.cloudDate,
                    newer: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataOptionCard extends StatefulWidget {
  final String name;
  final ConflictType type;
  final IconData icon;
  final String date;
  final bool newer;
  const DataOptionCard({
    super.key,
    required this.name,
    required this.type,
    required this.icon,
    required this.date,
    required this.newer,
  });

  @override
  State<DataOptionCard> createState() => _DataOptionCardState();
}

class _DataOptionCardState extends State<DataOptionCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          color: Palette.box1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AdaptiveText(
                "${widget.name} data",
                fontSize: 24,
              ),
              AdaptiveText(
                "${widget.date} ${widget.newer ? "(newer)" : "(older)"}",
                textAlign: TextAlign.center,
              ),
              AdaptiveIcon(
                widget.icon,
                size: 48,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.newer ? Colors.lightGreen : Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context, widget.type);
                  },
                  child: Text(
                    "Keep ${widget.name} data",
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
