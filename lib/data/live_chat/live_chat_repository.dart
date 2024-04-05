import 'models/chat_message.dart';

abstract class LiveChatRepository {
  Future<void> connect({required String accessToken});
  Stream<ChatMessage> incomingMessages();
  Future<void> disconnect();
  Future<void> sendMessage({required String text});
  Future<List<ChatMessage>> loadMessages({
    required int page,
    required int limit,
  });
}
