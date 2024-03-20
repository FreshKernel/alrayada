import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/settings/settings_cubit.dart';
import 'sections/settings_about_section.dart';
import 'sections/settings_cart_section.dart';
import 'sections/settings_data_section.dart';
import 'sections/settings_general_section.dart';
import 'sections/settings_orders_section.dart';
import 'sections/settings_statistics_section.dart';
import 'sections/settings_support_section.dart';

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
            return ListView(
              children: [
                SettingsGeneralSection(state: state),
                SettingsCartSection(state: state),
                SettingsStatisticsSection(state: state),
                SettingsSupportSection(state: state),
                SettingsOrdersSection(state: state),
                const SettingsDataSection(),
                const SettingsAboutSection()
              ],
            );
          },
        ),
      ),
    );
  }
}
