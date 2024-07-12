import '../../../live_chat/data/models/live_chat_room.dart';

/// Also see [LiveChatApi]
abstract class AdminLiveChatApi {
  Future<List<LiveChatRoom>> getRooms({
    required int page,
    required int limit,
  });
  Future<void> deleteRoomById({required String roomId});
  Future<void> deleteAllRooms();
}
