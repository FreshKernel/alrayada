import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../l10n/app_localizations.dart';
import '../../../logic/settings/settings_cubit.dart';
import '../settings_section.dart';

class SettingsDataSection extends StatelessWidget {
  const SettingsDataSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.data,
      tiles: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TODO: Restore this
              // PlatformElevatedButton(
              //   onPressed: FavoriteService.clearAllFavorites,
              //   child: Text(translations.resetFavorites),
              //   cupertino: (context, platform) =>
              //       CupertinoElevatedButtonData(
              //     padding: const EdgeInsets.all(8),
              //   ),
              // ),
              PlatformElevatedButton(
                onPressed: () async {
                  context.read<SettingsCubit>().clearAllPrefs();
                  Navigator.of(context).pop();
                },
                child: Text(context.loc.clearPreferences),
                cupertino: (context, platform) => CupertinoElevatedButtonData(
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
