import 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoListSection;
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.tiles,
    super.key,
  });

  final String title;
  final List<Widget> tiles;

  Widget buildTileList() => ListView.builder(
        shrinkWrap: true,
        itemCount: tiles.length,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => tiles[index],
      );

  @override
  Widget build(BuildContext context) {
    if (isCupertino(context)) {
      return CupertinoListSection.insetGrouped(
        header: Padding(
          padding: EdgeInsetsDirectional.only(
            start: 15,
            bottom: 5 * MediaQuery.textScalerOf(context).scale(1),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        children: tiles,
      );
    }

    final tileList = buildTileList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            top: MediaQuery.textScalerOf(context).scale(24),
            bottom: MediaQuery.textScalerOf(context).scale(10),
            start: 24,
            end: 24,
          ),
          child: DefaultTextStyle(
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xffd3e3fd)
                  : const Color(0xff0b57d0),
            ),
            child: Text(title),
          ),
        ),
        tileList,
      ],
    );
  }
}
