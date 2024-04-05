import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/live_chat/live_chat_cubit.dart';
import '../../utils/extensions/scaffold_messenger_ext.dart';
import '../../widgets/errors/w_error.dart';
import '../../widgets/scroll_edge_detector.dart';
import 'live_chat_message_tile.dart';

class LiveChatMessagesList extends StatelessWidget {
  const LiveChatMessagesList({required this.scrollController, super.key});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LiveChatCubit, LiveChatState>(
      listener: (context, state) {
        if (state is LiveChatSendMessageFailure) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.unknownErrorWithMsg(state.exception.message),
          );
          return;
        }

        if (state is LiveChatConnectFailure) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.unknownErrorWithMsg(state.exception.message),
          );
          return;
        }
      },
      builder: (context, state) {
        if (state is LiveChatConnectInProgress) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (state is LiveChatConnectFailure) {
          return ErrorWithTryAgain(
            onTryAgain: () => context.read<LiveChatCubit>().connect(),
          );
        }
        final messages = state.messages;
        return ScrollEdgeDetector(
          onTop: () {},
          child: ListView.builder(
            controller: scrollController,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return LiveChatMessageTile(
                message: message,
              );
            },
          ),
        );
      },
    );
  }
}
