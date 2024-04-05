import 'dart:async' show StreamSubscription;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/live_chat/live_chat_exceptions.dart';
import '../../data/live_chat/live_chat_repository.dart';
import '../../data/live_chat/models/chat_message.dart';
import '../auth/auth_cubit.dart';

part 'live_chat_state.dart';

class LiveChatCubit extends Cubit<LiveChatState> {
  LiveChatCubit({
    required this.liveChatRepository,
    required this.authCubit,
  }) : super(const LiveChatInitial());

  final LiveChatRepository liveChatRepository;
  final AuthCubit authCubit;
  late StreamSubscription<ChatMessage> _connectionSubscription;

  Future<void> connect() async {
    try {
      emit(const LiveChatConnectInProgress());
      final currentMessages = await liveChatRepository.loadMessages(
        page: 1,
        limit: 10,
      );
      await liveChatRepository.connect(
        accessToken: authCubit.state.requireUserCredential.accessToken,
      );
      _connectionSubscription =
          liveChatRepository.incomingMessages().listen((message) {
        emit(LiveChatNewMessageReceived(
          messages: [...state.messages, message],
        ));
      });
      emit(LiveChatConnectSuccess(
        messages: currentMessages,
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
      emit(LiveChatSendMessageInProgress(messages: state.messages));
      await liveChatRepository.sendMessage(text: text);
      emit(LiveChatSendMessageSuccess(messages: state.messages));
    } on LiveChatException catch (e) {
      emit(LiveChatSendMessageFailure(e, messages: state.messages));
    }
  }

  @override
  Future<void> close() {
    _connectionSubscription.cancel();
    return super.close();
  }
}
