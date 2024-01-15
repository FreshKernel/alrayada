import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fresh_base_package/fresh_base_package.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/settings/settings_cubit.dart';
import '../../utils/constants/constants.dart';

import '/screens/settings/w_select_theme_dialog.dart';
import 'w_option_checkbox.dart';
import 'w_settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.settings),
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final settingsBloc = context.read<SettingsCubit>();
            return ListView(
              children: [
                SettingsSection(
                  title: context.loc.general,
                  tiles: [
                    ListTile(
                      title: Text(context.loc.appLanguage),
                      subtitle: Text(context.loc.appLanguageDesc),
                      leading: const Icon(Icons.language),
                      trailing: DropdownButton<AppLanguague>(
                        value: state.languague,
                        items: AppLanguague.values
                            .map(
                              (e) => DropdownMenuItem<AppLanguague>(
                                value: e,
                                child: Text(e.valueName.replaceFirst(
                                  AppLanguague.system.valueName,
                                  context.loc.system,
                                )),
                              ),
                            )
                            .toList(),
                        onChanged: (newLanguague) {
                          if (newLanguague == null) {
                            return;
                          }
                          context
                              .read<SettingsCubit>()
                              .updateSettings(state.copyWith(
                                languague: newLanguague,
                              ));
                        },
                      ),
                    ),
                    OptionCheckbox(
                      title: context.loc.animations,
                      description: context.loc.animationsDesc,
                      onChanged: settingsBloc.toggleSetAnimationsEnabled,
                      value: state.isAnimationsEnabled,
                      leading: Icon(
                        isCupertino(context)
                            ? CupertinoIcons.play_arrow
                            : Icons.play_circle_outline,
                        semanticLabel: context.loc.animations,
                      ),
                    ),
                    ListTile(
                      onTap: () => showPlatformDialog(
                        context: context,
                        builder: (context) => const SelectThemeDialog(),
                      ),
                      title: Text(context.loc.themeMode),
                      subtitle: Text(context.loc.themeModeSettingsDesc),
                      leading: Icon(
                        isCupertino(context)
                            ? CupertinoIcons.sun_max
                            : Icons.wb_sunny_outlined,
                        semanticLabel: context.loc.themeMode,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: context.loc.shoppingCart,
                  tiles: [
                    OptionCheckbox(
                      title: context.loc.confirmDeleteCartItem,
                      description:
                          context.loc.confirmDeleteCartItemSettingsDesc,
                      onChanged: settingsBloc.toggleConfirmDeleteCartItem,
                      value: state.confirmDeleteCartItem,
                      leading: Icon(
                        isCupertino(context)
                            ? CupertinoIcons.delete
                            : Icons.delete_outline,
                        semanticLabel: context.loc.confirmDeleteCartItem,
                      ),
                    ),
                    OptionCheckbox(
                      title: context.loc.clearCartAfterCheckout,
                      description:
                          context.loc.clearCartAfterCheckoutSettingsDesc,
                      onChanged: settingsBloc.toggleClearCartAfterCheckout,
                      value: state.clearCartAfterCheckout,
                      leading: Icon(
                        isCupertino(context)
                            ? CupertinoIcons.clear
                            : Icons.clear,
                        semanticLabel: context.loc.clearCartAfterCheckout,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: context.loc.statistics,
                  tiles: [
                    OptionCheckbox(
                      title: context.loc.forceUseScrollableChart,
                      description:
                          context.loc.forceUseScrollableChartSettingsDesc,
                      onChanged: settingsBloc.toggleForceUseScrollableChart,
                      value: state.forceUseScrollableChart,
                      leading: const Icon(
                        Icons.tune,
                      ),
                    ),
                    OptionCheckbox(
                      title: context.loc.preferNumbersInChartMonths,
                      description:
                          context.loc.preferNumbersInChartMonthsSettingsDesc,
                      onChanged: settingsBloc.toggleUseMonthNumberInChart,
                      value: state.useMonthNumberInChart,
                      leading: Icon(
                        isCupertino(context)
                            ? CupertinoIcons.chart_bar
                            : Icons.insert_chart_outlined,
                        semanticLabel: context.loc.preferNumbersInChartMonths,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: context.loc.support,
                  tiles: [
                    OptionCheckbox(
                      title: context.loc.unFocusAfterSendMessage,
                      description:
                          context.loc.unFocusAfterSendMessageSettingsDesc,
                      onChanged: settingsBloc.toggleUnFocusAfterSendMsg,
                      value: state.unFocusAfterSendMsg,
                      leading: Icon(
                        isCupertino(context)
                            ? CupertinoIcons.paperplane
                            : Icons.send,
                        semanticLabel: context.loc.unFocusAfterSendMessage,
                      ),
                    ),
                    OptionCheckbox(
                      title: context.loc.useClassicMessageBubble,
                      description:
                          context.loc.useClassicMessageBubbleSettingsDesc,
                      onChanged: settingsBloc.toggleUseClassicMsgBubble,
                      value: state.useClassicMsgBubble,
                      leading: Icon(
                        isCupertino(context)
                            ? CupertinoIcons.chat_bubble
                            : Icons.chat_bubble,
                        semanticLabel: context.loc.useClassicMessageBubble,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: context.loc.orders,
                  tiles: [
                    OptionCheckbox(
                      title: context.loc.showOrderItemNotes,
                      description: context.loc.showOrderItemNotesSettingsDesc,
                      onChanged: settingsBloc.toggleShowOrderItemNotes,
                      value: state.showOrderItemNotes,
                      leading: Icon(
                        isCupertino(context)
                            ? CupertinoIcons.doc_text
                            : Icons.description,
                        semanticLabel: context.loc.showOrderItemNotes,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
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
                              settingsBloc.clearAllPrefs();
                              Navigator.of(context).pop();
                            },
                            child: Text(context.loc.clearPreferences),
                            cupertino: (context, platform) =>
                                CupertinoElevatedButtonData(
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: context.loc.aboutApp,
                  tiles: [
                    const AboutAppListTile(),
                    Align(
                      alignment: Alignment.center,
                      child: PlatformTextButton(
                        child: Text(context.loc.developedByWithDeveloperName(
                            Constants.developerName)),
                        onPressed: () => launchUrlString(
                          Constants.developerUrl,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
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
