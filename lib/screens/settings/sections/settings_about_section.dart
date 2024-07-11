import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fresh_base_package/fresh_base_package.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../constants.dart';
import '../../../gen/pubspec.g.dart';
import '../../../l10n/app_localizations.dart';
import '../settings_section.dart';

class SettingsAboutSection extends StatelessWidget {
  const SettingsAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.aboutApp,
      tiles: [
        AboutListTile(
          applicationIcon: const FlutterLogo(),
          aboutBoxChildren: [
            TextButton(
              onPressed: () => launchUrlString(Constants.privacyPolicy),
              child: Text(context.loc.privacyPolicy),
            )
          ],
          applicationLegalese: 'MIT',
          applicationVersion: 'v${Pubspec.version} (${Pubspec.versionBuild})',
          icon: Icon(
            PlatformChecker.defaultLogic().isAppleSystem()
                ? Icons.apple
                : Icons.android,
            semanticLabel: context.loc.version,
          ),
        ),
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
