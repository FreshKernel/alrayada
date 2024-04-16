part of 'live_chat_cubit.dart';

@immutable
class LiveChatMessagesState extends Equatable {
  const LiveChatMessagesState({
    this.messages = const [],
    this.page = 1,
    this.hasReachedLastPage = false,
  });

  final List<ChatMessage> messages;
  final int page;
  final bool hasReachedLastPage;

  @override
  List<Object?> get props => [
        messages,
        page,
        hasReachedLastPage,
      ];

  LiveChatMessagesState copyWith({
    List<ChatMessage>? messages,
    int? page,
    bool? hasReachedLastPage,
  }) {
    return LiveChatMessagesState(
      messages: messages ?? this.messages,
      page: page ?? this.page,
      hasReachedLastPage: hasReachedLastPage ?? this.hasReachedLastPage,
    );
  }
}

@immutable
sealed class LiveChatState extends Equatable {
  const LiveChatState({
    this.messagesState = const LiveChatMessagesState(),
  });

  final LiveChatMessagesState messagesState;

  @override
  List<Object?> get props => [messagesState];
}

class LiveChatInitial extends LiveChatState {
  const LiveChatInitial();
}

// Send message

class LiveChatSendMessageInProgress extends LiveChatState {
  const LiveChatSendMessageInProgress({required super.messagesState});
}

class LiveChatSendMessageSuccess extends LiveChatState {
  const LiveChatSendMessageSuccess({required super.messagesState});
}

class LiveChatSendMessageFailure extends LiveChatState {
  const LiveChatSendMessageFailure(
    this.exception, {
    required super.messagesState,
  });

  final LiveChatException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// Connect

class LiveChatConnectInProgress extends LiveChatState {
  const LiveChatConnectInProgress();
}

class LiveChatConnectSuccess extends LiveChatState {
  const LiveChatConnectSuccess({required super.messagesState});
}

class LiveChatConnectFailure extends LiveChatState {
  const LiveChatConnectFailure(this.exception);

  final LiveChatException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

class LiveChatLoadMoreInProgress extends LiveChatState {
  const LiveChatLoadMoreInProgress({required super.messagesState});
}

// Disconnect

class LiveChatDisconnectInProgress extends LiveChatState {
  const LiveChatDisconnectInProgress();
}

class LiveChatDisconnectSuccess extends LiveChatState {
  const LiveChatDisconnectSuccess();
}

class LiveChatDisconnectFailure extends LiveChatState {
  const LiveChatDisconnectFailure(this.exception);

  final LiveChatException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// Message events

class LiveChatNewMessageReceived extends LiveChatState {
  const LiveChatNewMessageReceived({required super.messagesState});
}
