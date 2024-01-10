import 'package:freezed_annotation/freezed_annotation.dart';

import '../user/models/user.dart';

part 'm_chat_message.freezed.dart';
part 'm_chat_message.g.dart';

/// Only for admin
@freezed
class ChatRoom with _$ChatRoom {
  const factory ChatRoom({
    required String id,
    required String chatRoomId,
    required DateTime updatedAt,
    required UserData userData,
  }) = _ChatRoom;

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String text,
    required String senderId,
    required DateTime createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

extension SharedChatMessage on ChatMessage {
  bool isMe(String userId) => userId == senderId;
}
