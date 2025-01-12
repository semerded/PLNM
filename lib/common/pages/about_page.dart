import 'package:flutter/material.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/common/widgets/switch_dark_mode_icon_button.dart';
import 'package:keeper_of_projects/data.dart';

class AboutPage extends StatefulWidget {
  final VoidCallback callback;
  final bool loggedIn;
  AboutPage({
    super.key,
    this.callback = _defaultCallback,
    this.loggedIn = true,
  }) {
    if (!loggedIn) {
      assert(
        callback != _defaultCallback,
        "Custom callback must be provided when not logged in to provide a callback for the switch darkmode function",
      );
    }
  }

  static void _defaultCallback() {
    // do nothing with default callback
  }

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        backgroundColor: Palette.primary,
        title: const Text("About PLNM"),
        actions: [
          if (!widget.loggedIn)
            SwitchDarkModeIconButton(
                onSwitch: () => setState(() {
                      widget.callback();
                    }))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AdaptiveTitleText("PLNM"),
            AdaptiveText("Developed by Sem Van Broekhoven, 2023 - 2024"),
            AdaptiveDivider(),
            AdaptiveText(
              """This program uses Google Drive as cloud storage, 
              this means that the data is in the hands of the user instead of in a database managed by me. 
              I have no access to any of your private data nor the right to access it. The app will create a new folder called 'com.semerded', 
              from then on it will only work within this folder.""",
            ),
            AdaptiveDivider(),
            AdaptiveText("The code is open-source and available on GitHub"),
            ElevatedButton.icon(
              onPressed: () {},
              label: const Text(
                "Github",
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.open_in_new_outlined,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF171515),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Palette.text,
                      ),
                      borderRadius: BorderRadius.circular(8))),
              iconAlignment: IconAlignment.end,
            ),
            AdaptiveText("""any bugs and issues can be mentioned on GitHub"""),
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
