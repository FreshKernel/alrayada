part of 'live_chat_cubit.dart';

@immutable
sealed class LiveChatState extends Equatable {
  const LiveChatState({
    this.messages = const [],
  });

  final List<ChatMessage> messages;

  @override
  List<Object?> get props => [messages];
}

class LiveChatInitial extends LiveChatState {
  const LiveChatInitial();
}

// Send message

class LiveChatSendMessageInProgress extends LiveChatState {
  const LiveChatSendMessageInProgress({required super.messages});
}

class LiveChatSendMessageSuccess extends LiveChatState {
  const LiveChatSendMessageSuccess({required super.messages});
}

class LiveChatSendMessageFailure extends LiveChatState {
  const LiveChatSendMessageFailure(this.exception, {required super.messages});

  final LiveChatException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// Connect

class LiveChatConnectInProgress extends LiveChatState {
  const LiveChatConnectInProgress();
}

class LiveChatConnectSuccess extends LiveChatState {
  const LiveChatConnectSuccess({required super.messages});
}

class LiveChatConnectFailure extends LiveChatState {
  const LiveChatConnectFailure(this.exception);

  final LiveChatException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
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
  const LiveChatNewMessageReceived({required super.messages});
}
