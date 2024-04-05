import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';

import '../../services/dio_service.dart';
import '../../utils/constants/routes_constants.dart';
import '../../utils/server.dart';
import 'live_chat_exceptions.dart';
import 'live_chat_repository.dart';
import 'models/chat_message.dart';

class LiveChatRepositoryImpl extends LiveChatRepository {
  IOWebSocketChannel? _channel;
  @override
  Future<void> connect({required String accessToken}) async {
    if (_channel != null) {
      // Close previous connection
      await disconnect();
    }
    _channel = IOWebSocketChannel.connect(
      Uri.parse(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.liveChatRoutes.userLiveChat,
          isWebSocket: true,
        ),
      ),
      headers: {
        'Authorization': 'Bearer $accessToken',
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
  Future<List<ChatMessage>> loadMessages({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await DioService.instance.dio.get<List>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.liveChatRoutes.getMessages,
        ),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      final responseData = response.data;
      if (responseData == null) {
        throw StateError('The response data can not be null');
      }
      return responseData.map((e) => ChatMessage.fromJson(e)).toList();
    } on DioException catch (e) {
      throw UnknownLiveChatException(message: e.message.toString());
    } catch (e) {
      throw UnknownLiveChatException(message: e.toString());
    }
  }
}
