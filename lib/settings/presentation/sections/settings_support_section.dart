import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../common/localizations/app_localization_extension.dart';
import '../../logic/settings_cubit.dart';
import '../settings_section.dart';

class SettingsSupportSection extends StatelessWidget {
  const SettingsSupportSection({required this.state, super.key});

  final SettingsState state;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: context.loc.support,
      tiles: [
        SwitchListTile.adaptive(
          title: Text(context.loc.unFocusAfterSendMessage),
          subtitle: Text(context.loc.unFocusAfterSendMessageSettingsDesc),
          secondary: Icon(
            isCupertino(context) ? CupertinoIcons.paperplane : Icons.send,
            semanticLabel: context.loc.unFocusAfterSendMessage,
          ),
          onChanged: (value) => context.read<SettingsCubit>().updateSettings(
              state.copyWith(unFocusAfterSendMsg: !state.unFocusAfterSendMsg)),
          value: state.unFocusAfterSendMsg,
        ),
        SwitchListTile.adaptive(
          title: Text(context.loc.useClassicMessageBubble),
          subtitle: Text(context.loc.useClassicMessageBubbleSettingsDesc),
          secondary: Icon(
            isCupertino(context)
                ? CupertinoIcons.chat_bubble
                : Icons.chat_bubble,
            semanticLabel: context.loc.useClassicMessageBubble,
          ),
          onChanged: (value) => context.read<SettingsCubit>().updateSettings(
              state.copyWith(useClassicMsgBubble: !state.useClassicMsgBubble)),
          value: state.useClassicMsgBubble,
        ),
      ],
    );
  }
}
