import 'package:meta/meta.dart';

@immutable
sealed class LiveChatException implements Exception {
  const LiveChatException({
    required this.message,
  });

  final String message;

  @override
  String toString() => message;
}

class UnknownLiveChatException extends LiveChatException {
  const UnknownLiveChatException({required super.message});
}
