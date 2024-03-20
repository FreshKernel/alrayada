import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../l10n/app_localizations.dart';
import '../../../logic/settings/settings_cubit.dart';
import '../settings_section.dart';

class SettingsOrdersSection extends StatelessWidget {
  const SettingsOrdersSection({required this.state, super.key});

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.orders,
      tiles: [
        SwitchListTile.adaptive(
          title: Text(context.loc.showOrderItemNotes),
          subtitle: Text(context.loc.showOrderItemNotesSettingsDesc),
          secondary: Icon(
            isCupertino(context) ? CupertinoIcons.doc_text : Icons.description,
            semanticLabel: context.loc.showOrderItemNotes,
          ),
          onChanged: (value) => context.read<SettingsCubit>().updateSettings(
              state.copyWith(showOrderItemNotes: !state.showOrderItemNotes)),
          value: state.showOrderItemNotes,
        ),
      ],
    );
  }
}
