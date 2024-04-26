import 'package:meta/meta.dart';

import 'admin/admin_live_chat_api.dart';
import 'models/chat_message.dart';

@immutable
sealed class LiveChatConnectionType {
  const LiveChatConnectionType();
}

/// Connect as client in order for admin to join the client
class LiveChatConnectClientUser extends LiveChatConnectionType {
  const LiveChatConnectClientUser();
}

/// Connect to the client room by [roomClientUserId] as admin user
class LiveChatConnectAdminUser extends LiveChatConnectionType {
  const LiveChatConnectAdminUser({
    required this.roomClientUserId,
  });

  final String roomClientUserId;
}

/// Also see [AdminLiveChatApi]
abstract class LiveChatApi {
  Future<void> connect({
    required LiveChatConnectionType connectionType,
  });
  Stream<ChatMessage> incomingMessages();
  Future<void> disconnect();
  Future<void> sendMessage({required String text});
  Future<List<ChatMessage>> getMessages({
    required int page,
    required int limit,
    required LiveChatConnectionType connectionType,
  });
}
