import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../l10n/app_localizations.dart';
import '../../../logic/settings/settings_cubit.dart';
import '../../../logic/settings/settings_data.dart';
import '../../../utils/extensions/build_context_ext.dart';
import '../select_theme_dialog.dart';
import '../settings_section.dart';

class SettingsGeneralSection extends StatelessWidget {
  const SettingsGeneralSection({
    required this.state,
    super.key,
  });

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.general,
      tiles: [
        ListTile(
          title: Text(context.loc.appLanguage),
          subtitle: Text(context.loc.appLanguageDesc),
          leading: const Icon(Icons.language),
          trailing: DropdownMenu<AppLanguague>(
            initialSelection: state.appLanguague,
            dropdownMenuEntries: AppLanguague.values
                .map(
                  (e) => DropdownMenuEntry<AppLanguague>(
                    value: e,
                    label: e.valueName.replaceFirst(
                      AppLanguague.system.valueName,
                      context.loc.system,
                    ),
                  ),
                )
                .toList(),
            onSelected: (newLanguague) {
              if (newLanguague == null) {
                return;
              }
              context.read<SettingsCubit>().updateSettings(state.copyWith(
                    appLanguague: newLanguague,
                  ));
            },
          ),
        ),
        ListTile(
          onTap: () => showModalBottomSheet(
            context: context,
            showDragHandle: true,
            constraints: const BoxConstraints(maxWidth: 640),
            builder: (context) {
              // This is a different widget and since the show
              // ModalBottomSheet() doesn't rebuild when the parent
              // widget rebuilt, then we need to it ourseleves
              return BlocSelector<SettingsCubit, SettingsState, AppThemeMode>(
                selector: (state) => state.themeMode,
                builder: (context, state) => SelectThemeModeDialog(
                  themeMode: state,
                ),
              );
            },
          ),
          title: Text(context.loc.themeMode),
          subtitle: Text(context.loc.themeModeSettingsDesc),
          leading: Icon(
            isCupertino(context)
                ? (context.isDark
                    ? CupertinoIcons.moon_fill
                    : CupertinoIcons.sun_max)
                : (context.isDark ? Icons.nightlight : Icons.wb_sunny_outlined),
            semanticLabel: context.loc.themeMode,
          ),
        ),
        Visibility(
          visible: state.themeMode == AppThemeMode.auto,
          maintainState: true,
          maintainAnimation: true,
          child: AnimatedOpacity(
            opacity: state.themeMode == AppThemeMode.auto ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            child: SwitchListTile.adaptive(
              value: state.darkDuringDayInAutoMode,
              onChanged: (newValue) {
                context.read<SettingsCubit>().updateSettings(
                      state.copyWith(
                        darkDuringDayInAutoMode: newValue,
                      ),
                    );
              },
              title: Text(context.loc.darkModeDuringDay),
              subtitle: Text(
                context.loc.darkModeDuringDayDesc,
              ),
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
        ),
        SwitchListTile.adaptive(
          value: state.useDynamicColors,
          onChanged: (value) => context.read<SettingsCubit>().updateSettings(
                state.copyWith(useDynamicColors: value),
              ),
          title: Text(context.loc.dynamicColors),
          subtitle: Text(context.loc.automaticallyAdaptToSystemColors),
          secondary: Icon(
            isCupertino(context)
                ? CupertinoIcons.paintbrush_fill
                : Icons.palette,
            semanticLabel: context.loc.dynamicColors,
          ),
        ),
        SwitchListTile.adaptive(
          title: Text(context.loc.useClassicMaterial),
          subtitle: Text(
            context.loc.useClassicMaterialDesc,
          ),
          secondary: const Icon(Icons.android),
          value: state.themeSystem == AppThemeSystem.material2,
          onChanged: (value) => context.read<SettingsCubit>().updateSettings(
                state.copyWith(
                  themeSystem: value
                      ? AppThemeSystem.material2
                      : AppThemeSystem.material3,
                ),
              ),
        ),
        SwitchListTile.adaptive(
          title: Text(context.loc.animations),
          subtitle: Text(context.loc.animationsDesc),
          secondary: Icon(
            isCupertino(context)
                ? CupertinoIcons.play_arrow
                : Icons.play_circle_outline,
            semanticLabel: context.loc.animations,
          ),
          onChanged: (value) => context.read<SettingsCubit>().updateSettings(
              state.copyWith(isAnimationsEnabled: !state.isAnimationsEnabled)),
          value: state.isAnimationsEnabled,
        ),
        ListTile(
          title: Text(context.loc.layoutMode),
          subtitle: Text(context.loc.layoutModeDesc),
          leading: const Icon(Icons.view_module),
          // TODO: There is a bug in DropdownMenu widgets in this file when open it
          trailing: DropdownMenu<AppLayoutMode>(
            initialSelection: state.layoutMode,
            dropdownMenuEntries: AppLayoutMode.values
                .map(
                  (e) => DropdownMenuEntry<AppLayoutMode>(
                    value: e,
                    label: e.getLabel(context.loc),
                  ),
                )
                .toList(),
            onSelected: (newLayout) {
              if (newLayout == null) {
                return;
              }
              context
                  .read<SettingsCubit>()
                  .updateSettings(state.copyWith(layoutMode: newLayout));
            },
          ),
        ),
      ],
    );
  }
}
