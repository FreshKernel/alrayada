import 'dart:async' show StreamSubscription;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/live_chat/live_chat_exceptions.dart';
import '../../data/live_chat/live_chat_repository.dart';
import '../../data/live_chat/models/chat_message.dart';
import '../auth/auth_cubit.dart';
import './admin/admin_live_chat_cubit.dart';

part 'live_chat_state.dart';

/// Responsible for live chat messages for both admin and client
/// Also see [AdminLiveChatCubit]
class LiveChatCubit extends Cubit<LiveChatState> {
  LiveChatCubit({
    required this.liveChatRepository,
    required this.authCubit,
  }) : super(const LiveChatInitial());

  final LiveChatRepository liveChatRepository;
  final AuthCubit authCubit;
  late StreamSubscription<ChatMessage> _connectionSubscription;

  static const int _limit = 15;

  Future<void> connect(LiveChatConnectionType connectionType) async {
    try {
      emit(const LiveChatConnectInProgress());
      final currentMessages = await liveChatRepository.getMessages(
        connectionType: connectionType,
        page: 1,
        limit: _limit,
      );
      await liveChatRepository.connect(
        connectionType: connectionType,
        accessToken: authCubit.state.requireUserCredential.accessToken,
      );
      _connectionSubscription =
          liveChatRepository.incomingMessages().listen((message) {
        emit(LiveChatNewMessageReceived(
          messagesState: LiveChatMessagesState(
            messages: [...state.messagesState.messages, message],
          ),
        ));
      });
      emit(LiveChatConnectSuccess(
        messagesState: LiveChatMessagesState(
          messages: currentMessages,
        ),
      ));
    } on LiveChatException catch (e) {
      emit(LiveChatConnectFailure(e));
    }
  }

  Future<void> disconnect() async {
    try {
      emit(const LiveChatDisconnectInProgress());
      await liveChatRepository.disconnect();
      _connectionSubscription.cancel();
      emit(const LiveChatDisconnectSuccess());
    } on LiveChatException catch (e) {
      emit(LiveChatDisconnectFailure(e));
    }
  }

  Future<void> sendMessage({required String text}) async {
    try {
      emit(
        LiveChatSendMessageInProgress(
          messagesState: state.messagesState,
        ),
      );
      await liveChatRepository.sendMessage(text: text);
      emit(LiveChatSendMessageSuccess(
        messagesState: state.messagesState,
      ));
    } on LiveChatException catch (e) {
      emit(LiveChatSendMessageFailure(e, messagesState: state.messagesState));
    }
  }

  Future<void> loadMoreMessages(LiveChatConnectionType connectionType) async {
    if (state.messagesState.hasReachedLastPage) {
      return;
    }
    if (state is LiveChatLoadMoreInProgress) {
      // In case if the function called more than once
      return;
    }
    try {
      emit(LiveChatLoadMoreInProgress(
        messagesState: state.messagesState.copyWith(
          page: state.messagesState.page + 1,
        ),
      ));
      final moreMessages = await liveChatRepository.getMessages(
        connectionType: connectionType,
        page: state.messagesState.page,
        limit: _limit,
      );
      emit(LiveChatConnectSuccess(
        messagesState: state.messagesState.copyWith(
          messages: [
            // TODO: At the moment the messages is not sorted as it should from the backend side
            ...moreMessages,
            ...state.messagesState.messages,
          ],
          hasReachedLastPage: moreMessages.isEmpty,
        ),
      ));
    } on LiveChatException catch (e) {
      emit(LiveChatConnectFailure(e));
    }
  }

  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }
}
