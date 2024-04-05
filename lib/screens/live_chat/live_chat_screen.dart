import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/live_chat/live_chat_cubit.dart';
import 'live_chat_messages_list.dart';
import 'live_chat_new_message.dart';

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({super.key});

  static const routeName = '/liveChat';

  @override
  State<LiveChatScreen> createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final _scrollController = ScrollController();
  late final LiveChatCubit _liveChatCubit;

  @override
  void dispose() {
    _scrollController.dispose();
    _liveChatCubit.disconnect();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _liveChatCubit = context.read<LiveChatCubit>();
    _liveChatCubit.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.support),
      ),
      body: Column(
        children: [
          Expanded(
            child: LiveChatMessagesList(
              scrollController: _scrollController,
            ),
          ),
          LiveChatNewMessage(
            scrollController: _scrollController,
          )
        ],
      ),
    );
  }
}
