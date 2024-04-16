import 'package:meta/meta.dart';

/// For admin usage only
@immutable
class LiveChatRoom {
  const LiveChatRoom({
    required this.id,
    required this.roomClientUserId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LiveChatRoom.fromJson(Map<String, Object?> map) {
    return LiveChatRoom(
      id: map['id'] as String,
      roomClientUserId: map['roomClientUserId'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'roomClientUserId': roomClientUserId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  final String id;
  final String roomClientUserId;
  final DateTime createdAt;
  final DateTime updatedAt;
}
