import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/text.dart';
import 'package:keeper_of_projects/data.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        backgroundColor: Palette.primary,
        title: Text("About ..."), // TODO change to app name
      ),
      body: const Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AdaptiveTitleText("... name"),
            AdaptiveText("Developed by Sem Van Broekhoven, 2023 - 2024"),
            AdaptiveDivider(),
            AdaptiveText(
              """This program uses Google Drive as cloud storage, 
              this means that the data is in the hands of the user instead of in a database managed by me. 
              I have no access to any of your private data nor the right to access it. The app will create a new folder called 'com.semerded', 
              from then on it will only work within this folder.""",
            ),
            AdaptiveDivider(),
            AdaptiveText("The code is opensource and available at: "),
            AdaptiveText(""""""),
          ],
        ),
      ),
    );
  }
}

class AdaptiveTitleText extends AdaptiveText {
  const AdaptiveTitleText(
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

class AdaptiveDivider extends StatelessWidget {
  const AdaptiveDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Palette.text,
    );
  }
}
