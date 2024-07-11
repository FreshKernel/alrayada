import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

@Deprecated('I might refactor this and use it or not using it at all')
class PlatformAdaptiveIcon extends StatelessWidget {
  const PlatformAdaptiveIcon({
    required this.iconData,
    required this.semanticLabel,
    required this.cupertinoIconData,
    super.key,
    this.materialIconData,
  });
  final IconData iconData;
  final IconData? materialIconData;
  final IconData? cupertinoIconData;
  final String semanticLabel;

  static IconData getPlatformIconData({
    required BuildContext context,
    required IconData iconData,
    IconData? materialIconData,
    IconData? cupertinoIconData,
  }) {
    if (isCupertino(context)) {
      return cupertinoIconData ?? iconData;
    }
    return materialIconData ?? iconData;
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      getPlatformIconData(
        context: context,
        iconData: iconData,
        materialIconData: materialIconData,
        cupertinoIconData: cupertinoIconData,
      ),
      semanticLabel: semanticLabel,
    );
  }
}
