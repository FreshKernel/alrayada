import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/settings/settings_cubit.dart';
import '../../utils/constants/constants.dart';
import '../../widgets/w_icon.dart';
import '/screens/settings/w_select_theme_dialog.dart';
import 'w_option_checkbox.dart';
import 'w_settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    final localicazations = context.loc;
    return Scaffold(
      appBar: AppBar(
        title: Text(localicazations.settings),
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            final settingsBloc = context.read<SettingsCubit>();
            return ListView(
              children: [
                SettingsSection(
                  title: localicazations.general,
                  tiles: [
                    OptionCheckbox(
                      title: localicazations.animations,
                      description:
                          localicazations.animationsDetailsSettingsDetails,
                      onChanged: settingsBloc.toggleSetAnimationsEnabled,
                      value: state.isAnimationsEnabled,
                      leading: PlatformAdaptiveIcon(
                        iconData: Icons.play_circle_outline,
                        cupertinoIconData: CupertinoIcons.play_arrow,
                        semanticLabel: localicazations.animations,
                      ),
                    ),
                    ListTile(
                      onTap: () => showPlatformDialog(
                        context: context,
                        builder: (context) => const SelectThemeDialog(),
                      ),
                      title: Text(localicazations.themeMode),
                      subtitle: Text(localicazations.themeModeSettingsDetails),
                      leading: PlatformAdaptiveIcon(
                        iconData: Icons.wb_sunny_outlined,
                        cupertinoIconData: CupertinoIcons.sun_max,
                        semanticLabel: localicazations.themeMode,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: localicazations.shoppingCart,
                  tiles: [
                    OptionCheckbox(
                      title: localicazations.confirmDeleteCartItem,
                      description:
                          localicazations.confirmDeleteCartItemSettingsDetails,
                      onChanged: settingsBloc.toggleConfirmDeleteCartItem,
                      value: state.confirmDeleteCartItem,
                      leading: PlatformAdaptiveIcon(
                        iconData: Icons.delete_outline,
                        cupertinoIconData: CupertinoIcons.delete,
                        semanticLabel: localicazations.confirmDeleteCartItem,
                      ),
                    ),
                    OptionCheckbox(
                      title: localicazations.clearCartAfterCheckout,
                      description:
                          localicazations.clearCartAfterCheckoutSettingsDetails,
                      onChanged: settingsBloc.toggleClearCartAfterCheckout,
                      value: state.clearCartAfterCheckout,
                      leading: PlatformAdaptiveIcon(
                        iconData: Icons.clear,
                        cupertinoIconData: CupertinoIcons.clear,
                        semanticLabel: localicazations.clearCartAfterCheckout,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: localicazations.statistics,
                  tiles: [
                    OptionCheckbox(
                      title: localicazations.forceUseScrollableChart,
                      description: localicazations
                          .forceUseScrollableChartSettingsDetails,
                      onChanged: settingsBloc.toggleForceUseScrollableChart,
                      value: state.forceUseScrollableChart,
                      leading: const Icon(
                        Icons.tune,
                      ),
                    ),
                    OptionCheckbox(
                      title: localicazations.preferNumbersInChartMonths,
                      description: localicazations
                          .preferNumbersInChartMonthsSettingsDetails,
                      onChanged: settingsBloc.toggleUseMonthNumberInChart,
                      value: state.useMonthNumberInChart,
                      leading: PlatformAdaptiveIcon(
                        iconData: Icons.insert_chart_outlined,
                        cupertinoIconData: CupertinoIcons.chart_bar,
                        semanticLabel:
                            localicazations.preferNumbersInChartMonths,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: localicazations.support,
                  tiles: [
                    OptionCheckbox(
                      title: localicazations.unFocusAfterSendMessage,
                      description: localicazations
                          .unFocusAfterSendMessageSettingsDetails,
                      onChanged: settingsBloc.toggleUnFocusAfterSendMsg,
                      value: state.unFocusAfterSendMsg,
                      leading: PlatformAdaptiveIcon(
                        iconData: Icons.send,
                        cupertinoIconData: CupertinoIcons.paperplane,
                        semanticLabel: localicazations.unFocusAfterSendMessage,
                      ),
                    ),
                    OptionCheckbox(
                      title: localicazations.useClassicMessageBubble,
                      description: localicazations
                          .useClassicMessageBubbleSettingsDetails,
                      onChanged: settingsBloc.toggleUseClassicMsgBubble,
                      value: state.useClassicMsgBubble,
                      leading: PlatformAdaptiveIcon(
                        iconData: Icons.chat_bubble,
                        cupertinoIconData: CupertinoIcons.chat_bubble,
                        semanticLabel: localicazations.useClassicMessageBubble,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: localicazations.orders,
                  tiles: [
                    OptionCheckbox(
                      title: localicazations.showOrderItemNotes,
                      description:
                          localicazations.showOrderItemNotesSettingsDetails,
                      onChanged: settingsBloc.toggleShowOrderItemNotes,
                      value: state.showOrderItemNotes,
                      leading: PlatformAdaptiveIcon(
                        iconData: Icons.description,
                        cupertinoIconData: CupertinoIcons.doc_text,
                        semanticLabel: localicazations.showOrderItemNotes,
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: localicazations.data,
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
                            child: Text(localicazations.clearPreferences),
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
                  title: localicazations.aboutApp,
                  tiles: [
                    const AboutAppListTile(),
                    Align(
                      alignment: Alignment.center,
                      child: PlatformTextButton(
                        child: Text(
                            localicazations.developedByWithDeveloperName(
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
    final translations = context.loc;
    return FutureBuilder(
      future: _loadDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        final packageDataInfo = snapshot.requireData;
        return PlatformListTile(
          title: Text(
            '${translations.appName} ${packageDataInfo.version} (${packageDataInfo.buildNumber})',
            textAlign: TextAlign.center,
          ),
          leading: PlatformAdaptiveIcon(
            cupertinoIconData: Icons.apple,
            iconData: Icons.android,
            semanticLabel: translations.version,
          ),
          onTap: () => showAboutDialog(context: context),
        );
      },
    );
  }
}
