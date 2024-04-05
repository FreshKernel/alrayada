import 'package:meta/meta.dart';

@immutable
class LiveChatRoom {
  const LiveChatRoom({
    required this.id,
    required this.clientUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LiveChatRoom.fromJson(Map<String, Object?> map) {
    return LiveChatRoom(
      id: map['id'] as String,
      clientUserId: map['clientUserId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'clientUserId': clientUserId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  final String id;
  final String clientUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
}
