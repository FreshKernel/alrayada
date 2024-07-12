import 'package:dio/dio.dart';

import '../../../common/constants/routes_constants.dart';
import '../../../common/dio_service.dart';
import '../../../common/extensions/dio_response_ext.dart';
import '../../../common/server.dart';
import '../../../live_chat/data/live_chat_exceptions.dart';
import '../../../live_chat/data/models/live_chat_room.dart';
import 'admin_live_chat_api.dart';

class RemoteAdminLiveChatApi extends AdminLiveChatApi {
  final _dio = DioService.instance.dio;
  @override
  Future<List<LiveChatRoom>> getRooms({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get<List>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.liveChatRoutes.adminRoutes.getRooms,
        ),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return response.dataOrThrow.map((e) => LiveChatRoom.fromJson(e)).toList();
    } on DioException catch (e) {
      throw UnknownLiveChatException(message: e.message.toString());
    } catch (e) {
      throw UnknownLiveChatException(message: e.toString());
    }
  }

  @override
  Future<void> deleteRoomById({required String roomId}) async {
    try {
      await _dio.delete(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.liveChatRoutes.adminRoutes.deleteRoom(roomId),
        ),
      );
    } on DioException catch (e) {
      throw UnknownLiveChatException(message: e.message.toString());
    } catch (e) {
      throw UnknownLiveChatException(message: e.toString());
    }
  }

  @override
  Future<void> deleteAllRooms() async {
    try {
      await _dio.delete(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.liveChatRoutes.adminRoutes.deleteRooms,
        ),
      );
    } on DioException catch (e) {
      throw UnknownLiveChatException(message: e.message.toString());
    } catch (e) {
      throw UnknownLiveChatException(message: e.toString());
    }
  }
}
