import 'package:flutter/material.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:keeper_of_projects/common/icons/drive_icon.dart';
import 'package:keeper_of_projects/common/widgets/rotate_drive_logo.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

class LoggedInCheckSync extends StatefulWidget {
  final RotateDriveLogo rotateDriveLogo;
  const LoggedInCheckSync({
    super.key,
    required this.rotateDriveLogo,
  });

  @override
  State<LoggedInCheckSync> createState() => _LoggedInCheckSyncState();
}

class _LoggedInCheckSyncState extends State<LoggedInCheckSync> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "googleUserCircleAvatar",
              child: GoogleUserCircleAvatar(
                identity: currentUser!,
              ),
            ),
            Container(
              width: 5,
            ),
            RotationTransition(turns: widget.rotateDriveLogo.animation, child: const DriveIcon()),
          ],
        ),
        AdaptiveText(
          "Checking If Cloud Sync Is Needed...",
          fontWeight: FontWeight.w800,
          fontSize: 28,
        ),
      ],
    );
  }
}
