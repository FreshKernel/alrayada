import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fresh_base_package/fresh_base_package.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/constants.dart';
import '../settings_section.dart';

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.aboutApp,
      tiles: [
        const AboutAppListTile(),
        Align(
          alignment: Alignment.center,
          child: PlatformTextButton(
            child: Text(context.loc
                .developedByWithDeveloperName(Constants.developerName)),
            onPressed: () => launchUrlString(
              Constants.developerUrl,
            ),
          ),
        )
      ],
    );
  }
}

class AboutAppListTile extends StatefulWidget {
  const AboutAppListTile({super.key});

  @override
  State<AboutAppListTile> createState() => AboutAppListTileState();
}

class AboutAppListTileState extends State<AboutAppListTile> {
  late final Future<PackageInfo> _loadDataFuture;

  @override
  void initState() {
    super.initState();
    _loadDataFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final packageDataInfo = snapshot.requireData;
        return AboutListTile(
          // title: Text(
          //   '${translations.appName} ${packageDataInfo.version} (${packageDataInfo.buildNumber})',
          //   textAlign: TextAlign.center,
          // ),
          // leading: PlatformAdaptiveIcon(
          //   cupertinoIconData: Icons.apple,
          //   iconData: Icons.android,
          //   semanticLabel: translations.version,
          // ),
          // onTap: () => showAboutDialog(context: context),
          applicationVersion:
              'v${packageDataInfo.version} (${packageDataInfo.buildNumber})',
          icon: Icon(
            PlatformChecker.defaultLogic().isAppleSystem()
                ? Icons.apple
                : Icons.android,
            semanticLabel: context.loc.version,
          ),
        );
      },
    );
  }
}
