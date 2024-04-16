import 'package:dio/dio.dart';

import '../../../services/dio_service.dart';
import '../../../utils/constants/routes_constants.dart';
import '../../../utils/error_response.dart';
import '../../../utils/extensions/dio_response_ext.dart';
import '../../../utils/server.dart';
import '../models/user.dart';
import 'admin_auth_exceptions.dart';
import 'admin_auth_repository.dart';

class AdminAuthRepositoryImpl extends AdminAuthRepository {
  final _dio = DioService.instance.dio;

  @override
  Future<void> deleteUserAccount({required String userId}) async {
    try {
      await _dio.delete(
        ServerConfigurations.getRequestUrl(
            RoutesConstants.authRoutes.adminRoutes.deleteUser),
        data: {
          'userId': userId,
        },
      );
    } catch (e) {
      throw UnknownAdminAuthException(message: e.toString());
    }
  }

  @override
  Future<List<User>> getAllUsers({
    required String searchQuery,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get<List>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.adminRoutes.getAllUsers,
        ),
        queryParameters: {
          'searchQuery': searchQuery,
          'page': page,
          'limit': limit,
        },
      );
      return response.dataOrThrow.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      throw UnknownAdminAuthException(message: e.toString());
    }
  }

  @override
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      await _dio.post(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.adminRoutes.sendNotificationToUser,
        ),
        data: {
          'userId': userId,
          'title': title,
          'body': body,
        },
      );
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        final code = ErrorResponse.fromJson(responseData.cast()).code;
        final exception = switch (code) {
          'NOTIFICATION_SERVER_ERROR' =>
            NotificationsServerException(message: e.message.toString()),
          String() => UnknownAdminAuthException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAdminAuthException(message: e.message.toString());
    } catch (e) {
      throw UnknownAdminAuthException(message: e.toString());
    }
  }

  @override
  Future<void> setAccountActivated({
    required String userId,
    required bool value,
  }) async {
    try {
      await _dio.patch(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.adminRoutes.setAccountActivated,
        ),
        data: {
          'userId': userId,
          'value': value,
        },
      );
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map) {
        final code = ErrorResponse.fromJson(responseData.cast()).code;
        final exception = switch (code) {
          'ALREADY_ACTIVATED' =>
            UserAlreadyNotActivatedException(message: e.message.toString()),
          'ALREADY_NOT_ACTIVATED' =>
            UserAlreadyNotActivatedException(message: e.message.toString()),
          String() => UnknownAdminAuthException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAdminAuthException(message: e.message.toString());
    } catch (e) {
      throw UnknownAdminAuthException(message: e.toString());
    }
  }
}
