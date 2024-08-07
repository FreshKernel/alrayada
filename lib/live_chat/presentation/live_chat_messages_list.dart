import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/extensions/scaffold_messenger_ext.dart';
import '../../common/localizations/app_localization_extension.dart';
import '../../common/presentation/widgets/errors/unknown_error.dart';
import '../../common/presentation/widgets/scroll_edge_detector.dart';
import '../data/live_chat_api.dart';
import '../logic/live_chat_cubit.dart';
import 'live_chat_message_tile.dart';

class LiveChatMessagesList extends StatelessWidget {
  const LiveChatMessagesList({
    required this.scrollController,
    required this.connectionType,
    super.key,
  });

  final ScrollController scrollController;
  final LiveChatConnectionType connectionType;

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
          return UnknownError(
            onTryAgain: () =>
                context.read<LiveChatCubit>().connect(connectionType),
          );
        }
        final messages = state.messagesState.messages;
        return Column(
          children: [
            if (state is LiveChatLoadMoreInProgress)
              const LinearProgressIndicator(),
            Expanded(
              child: ScrollEdgeDetector(
                onTop: () => context
                    .read<LiveChatCubit>()
                    .loadMoreMessages(connectionType),
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
              ),
            ),
          ],
        );
      },
    );
  }
}
