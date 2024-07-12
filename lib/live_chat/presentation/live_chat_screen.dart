import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/localizations/app_localization_extension.dart';
import '../../common/logic/connectivity/connectivity_cubit.dart';
import '../../common/presentation/widgets/errors/internet_error.dart';
import '../data/live_chat_api.dart';
import '../logic/live_chat_cubit.dart';
import 'live_chat_messages_list.dart';
import 'live_chat_new_message.dart';

@immutable
class LiveChatScreenArgs {
  const LiveChatScreenArgs({required this.connectionType});

  /// To whatever to connect as admin or client
  final LiveChatConnectionType connectionType;
}

class LiveChatScreen extends StatefulWidget {
  const LiveChatScreen({required this.args, super.key});

  final LiveChatScreenArgs args;

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
    _liveChatCubit.connect(widget.args.connectionType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.support),
      ),
      body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          if (state is ConnectivityDisconnected) {
            return const InternetError(onTryAgain: null);
          }
          return Column(
            children: [
              Expanded(
                child: LiveChatMessagesList(
                  scrollController: _scrollController,
                  connectionType: widget.args.connectionType,
                ),
              ),
              LiveChatNewMessage(
                scrollController: _scrollController,
              )
            ],
          );
        },
      ),
    );
  }
}
