import 'dart:math' as math show Random;

import 'package:flutter/material.dart' show BuildContext, ThemeMode;

import '../../l10n/app_localizations.dart';

enum AppThemeMode {
  dark,
  light,
  system,
  auto,
  random;

  ThemeMode toMaterialThemeMode({required bool darkDuringDayInAutoMode}) {
    switch (this) {
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.auto:
        // Could be improved
        final date = DateTime.now();
        final hours = date.hour;
        if (hours >= 1 && hours <= 12) {
          if (darkDuringDayInAutoMode) {
            return ThemeMode.dark;
          }
          return ThemeMode.light;
        } else if (hours >= 12 && hours <= 16) {
          if (darkDuringDayInAutoMode) {
            return ThemeMode.dark;
          }
          return ThemeMode.light;
        } else if (hours >= 16 && hours <= 21) {
          if (darkDuringDayInAutoMode) {
            return ThemeMode.light;
          }
          return ThemeMode.dark;
        } else if (hours >= 21 && hours <= 24) {
          if (darkDuringDayInAutoMode) {
            return ThemeMode.light;
          }
          return ThemeMode.dark;
        }
        return ThemeMode.dark;
      case AppThemeMode.random:
        final random = math.Random().nextInt(2);
        final theme = switch (random) {
          0 => ThemeMode.dark,
          1 => ThemeMode.light,
          int() => throw ArgumentError('We expect either 0 or 1'),
        };
        return theme;
    }
  }
}

enum AppThemeSystem { material3, material2, cupertino }

enum AppLayoutMode {
  auto,
  small,
  large;

  String getLabel(BuildContext context) {
    return switch (this) {
      AppLayoutMode.auto => context.loc.auto,
      AppLayoutMode.small => context.loc.small,
      AppLayoutMode.large => context.loc.large,
    };
  }
}

enum AppLanguague {
  system(valueName: 'System'),
  en(valueName: 'English'),
  ar(valueName: 'العربية');

  const AppLanguague({required this.valueName});

  final String valueName;
}
