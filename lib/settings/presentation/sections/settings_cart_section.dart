import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../common/localizations/app_localization_extension.dart';
import '../../logic/settings_cubit.dart';
import '../settings_section.dart';

class SettingsCartSection extends StatelessWidget {
  const SettingsCartSection({
    required this.state,
    super.key,
  });

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.shoppingCart,
      tiles: [
        SwitchListTile.adaptive(
          title: Text(context.loc.confirmDeleteCartItem),
          subtitle: Text(context.loc.confirmDeleteCartItemSettingsDesc),
          secondary: Icon(
            isCupertino(context) ? CupertinoIcons.delete : Icons.delete_outline,
            semanticLabel: context.loc.confirmDeleteCartItem,
          ),
          onChanged: (value) => context.read<SettingsCubit>().updateSettings(
              state.copyWith(
                  confirmDeleteCartItem: !state.confirmDeleteCartItem)),
          value: state.confirmDeleteCartItem,
        ),
        SwitchListTile.adaptive(
          title: Text(context.loc.clearCartAfterCheckout),
          subtitle: Text(context.loc.clearCartAfterCheckoutSettingsDesc),
          secondary: Icon(
            isCupertino(context) ? CupertinoIcons.clear : Icons.clear,
            semanticLabel: context.loc.clearCartAfterCheckout,
          ),
          onChanged: (value) => context.read<SettingsCubit>().updateSettings(
              state.copyWith(
                  clearCartAfterCheckout: !state.clearCartAfterCheckout)),
          value: state.clearCartAfterCheckout,
        ),
      ],
    );
  }
}
