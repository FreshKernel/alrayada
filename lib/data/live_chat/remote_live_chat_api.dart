import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';

import '../../services/dio_service.dart';
import '../../utils/constants/routes_constants.dart';
import '../../utils/extensions/dio_response_ext.dart';
import '../../utils/server.dart';
import 'live_chat_api.dart';
import 'live_chat_exceptions.dart';
import 'models/chat_message.dart';

class RemoteLiveChatApi extends LiveChatApi {
  IOWebSocketChannel? _channel;

  @override
  Future<void> connect({
    required LiveChatConnectionType connectionType,
  }) async {
    if (_channel != null) {
      // Close previous connection
      await disconnect();
    }
    final path = switch (connectionType) {
      LiveChatConnectClientUser() =>
        RoutesConstants.liveChatRoutes.userLiveChat,
      LiveChatConnectAdminUser() =>
        RoutesConstants.liveChatRoutes.adminRoutes.chatWithUser(
          roomClientUserId: connectionType.roomClientUserId,
        ),
    };
    _channel = IOWebSocketChannel.connect(
      Uri.parse(
        ServerConfigurations.getRequestUrl(
          path,
          isWebSocket: true,
        ),
      ),
      headers: {
        'Authorization': 'Bearer ${DioService.instance.accessToken}',
      },
    );
    await _channel?.ready;
  }

  IOWebSocketChannel get _requireWebSocketChannel {
    final stream = _channel;
    if (stream == null) {
      throw StateError(
        'You need to connect first before listen for incoming messages',
      );
    }
    return stream;
  }

  @override
  Stream<ChatMessage> incomingMessages() async* {
    final channel = _requireWebSocketChannel;
    await for (final messageJson in channel.stream) {
      final message = jsonDecode(messageJson);
      if (message is! Map<String, Object?>) {
        throw StateError(
          'The message is ${message.runtimeType} which is not expected',
        );
      }
      yield ChatMessage.fromJson(message);
    }
  }

  @override
  Future<void> disconnect() async {
    await _requireWebSocketChannel.sink.close();
    _channel = null;
  }

  @override
  Future<void> sendMessage({required String text}) async {
    _requireWebSocketChannel.sink.add(text);
  }

  @override
  Future<List<ChatMessage>> getMessages({
    required int page,
    required int limit,
    required LiveChatConnectionType connectionType,
  }) async {
    try {
      final path = switch (connectionType) {
        LiveChatConnectClientUser() =>
          RoutesConstants.liveChatRoutes.getMessages,
        LiveChatConnectAdminUser() =>
          RoutesConstants.liveChatRoutes.adminRoutes.getMessagesWithUser(
            roomClientUserId: connectionType.roomClientUserId,
          ),
      };
      final response = await DioService.instance.dio.get<List>(
        ServerConfigurations.getRequestUrl(path),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return response.dataOrThrow.map((e) => ChatMessage.fromJson(e)).toList();
    } on DioException catch (e) {
      throw UnknownLiveChatException(message: e.message.toString());
    } catch (e) {
      throw UnknownLiveChatException(message: e.toString());
    }
  }
}
