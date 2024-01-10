import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/settings/settings_cubit.dart';

class SelectThemeDialog extends StatelessWidget {
  const SelectThemeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return PlatformAlertDialog(
      title: Text(translations.themeMode),
      content: const SelectThemeDialogContent(),
      actions: [
        PlatformDialogAction(
          child: Text(translations.cancel),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}

class SelectThemeDialogContent extends StatelessWidget {
  const SelectThemeDialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.watch<SettingsCubit>();
    final translations = context.loc;
    final children = {
      ThemeMode.dark: Text(translations.dark),
      ThemeMode.light: Text(translations.light),
      ThemeMode.system: Text(translations.system),
    };
    if (isCupertino(context)) {
      return CupertinoSlidingSegmentedControl<ThemeMode>(
        groupValue: settingsCubit.state.themeMode,
        onValueChanged: (value) => settingsCubit.setThemeMode(value!),
        children: children,
      );
    }
    return ToggleButtons(
      isSelected: children.entries
          .map((e) => e.key == settingsCubit.state.themeMode)
          .toList(),
      onPressed: (index) {
        switch (index) {
          case 0:
            settingsCubit.setThemeMode(ThemeMode.dark);
            break;
          case 1:
            settingsCubit.setThemeMode(ThemeMode.light);
            break;
          case 2:
            settingsCubit.setThemeMode(ThemeMode.system);
            break;
        }
      },
      borderRadius: BorderRadius.circular(30),
      children: children.values
          .map((e) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: e,
              ))
          .toList(),
    );
  }
}
