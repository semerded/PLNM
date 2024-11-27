import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:keeper_of_projects/common/widgets/base/icon.dart';
import 'package:keeper_of_projects/common/widgets/base/text.dart';
import 'package:keeper_of_projects/data.dart';

class HomePageTitleDivider extends StatefulWidget {
  final String title;
  final List<TitleDividerInfo> titleDividerInfo;
  const HomePageTitleDivider({
    super.key,
    required this.title,
    required this.titleDividerInfo,
  });

  @override
  State<HomePageTitleDivider> createState() => _HomePageTitleDividerState();
}

class _HomePageTitleDividerState extends State<HomePageTitleDivider> {
  List<InlineSpan> _textSpanBuilder(TitleDividerInfo titleDividerInfo) {
    return [
      WidgetSpan(
        child: AdaptiveIcon(
          titleDividerInfo.icon,
          size: 14,
          color: Palette.subtext,
        ),
      ),
      TextSpan(
        style: TextStyle(color: Palette.subtext),
        text: titleDividerInfo.count.toString(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
      child: Row(
        children: [
          AdaptiveText(
            widget.title,
            fontSize: 24,
          ),
          TitleDivider(),
          RichText(
            text: TextSpan(children: () {
              List<InlineSpan> textSpanChilden = [];
              for (TitleDividerInfo titleDividerInfo in widget.titleDividerInfo) {
                textSpanChilden.addAll(_textSpanBuilder(titleDividerInfo));
              }
              return textSpanChilden;
            }()),
          ),
          TitleDivider()
        ],
      ),
    );
  }
}

class TitleDivider extends StatelessWidget {
  const TitleDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Divider(
          height: 2,
          thickness: 2,
          color: Palette.subtext,
        ),
      ),
    );
  }
}

class TitleDividerInfo {
  IconData icon;
  int count;
  TitleDividerInfo(this.icon, this.count);
}
