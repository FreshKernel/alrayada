import '../live_chat_repository.dart';
import '../models/live_chat_room.dart';

/// Also see [LiveChatRepository]
abstract class AdminLiveChatRepository {
  Future<List<LiveChatRoom>> getRooms({
    required int page,
    required int limit,
  });
  Future<void> deleteRoomById({required String roomId});
  Future<void> deleteAllRooms();
}
