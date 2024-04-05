import 'package:meta/meta.dart';

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, Object?> map) {
    return ChatMessage(
      id: map['id'] as String,
      text: map['text'] as String,
      senderId: map['senderId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'text': text,
      'senderId': senderId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  final String id;
  final String text;
  final String senderId;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool isMe(String userId) => userId == senderId;
}
