import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.bg,
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: Text("About ..."), // TODO change to app name
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AdaptiveTitleText("Why Google Drive?"),
            AdaptiveText("This app uses Google Drive to make cloud storage accessible for everyone. "),
          ],
        ),
      ),
    );
  }
}

class AdaptiveTitleText extends AdaptiveText {
  AdaptiveTitleText(
    super.data, {
    super.key,
    super.fontSize = 32,
    super.fontWeight,
    super.textAlign,
    super.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveText(
      data,
      fontSize: fontSize,
      key: key,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      textAlign: textAlign,
    );
  }
}
