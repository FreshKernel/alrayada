import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../common/localizations/app_localization_extension.dart';
import '../../settings/logic/settings_cubit.dart';
import '../logic/live_chat_cubit.dart';

class LiveChatNewMessage extends StatefulWidget {
  const LiveChatNewMessage({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  State<LiveChatNewMessage> createState() => _LiveChatNewMessageState();
}

class _LiveChatNewMessageState extends State<LiveChatNewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  ScrollController get scrollController => widget.scrollController;

  void _onSubmit() {
    if (_messageController.text.isEmpty) return;
    final settingsState = context.read<SettingsCubit>().state;
    if (settingsState.unFocusAfterSendMsg) {
      FocusScope.of(context).unfocus();
    }
    final message = _messageController.text;
    _messageController.clear();
    if (scrollController.positions.isNotEmpty) {
      if (!settingsState.isAnimationsEnabled) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } else {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
    context.read<LiveChatCubit>().sendMessage(text: message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: context.loc.enterYourMessageHere,
                labelText: context.loc.message,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.send,
              minLines: 1,
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) => setState(() {}),
              onSubmitted: (value) => _onSubmit(),
            ),
          ),
          PlatformIconButton(
            icon: Icon(
              _messageController.text.isEmpty
                  ? (isCupertino(context)
                      ? CupertinoIcons.paperplane
                      : Icons.send_outlined)
                  : (isCupertino(context)
                      ? CupertinoIcons.paperplane_fill
                      : Icons.send_rounded),
            ),
            onPressed: _messageController.text.isNotEmpty ? _onSubmit : null,
          ),
        ],
      ),
    );
  }
}
