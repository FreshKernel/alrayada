import 'package:dio/dio.dart';

import '../../../services/dio_service.dart';
import '../../../utils/constants/routes_constants.dart';
import '../../../utils/error_response.dart';
import '../../../utils/extensions/dio_response_ext.dart';
import '../../../utils/server.dart';
import '../models/user.dart';
import 'admin_user_exceptions.dart';
import 'admin_user_repository.dart';

class AdminUserRepositoryImpl extends AdminUserRepository {
  final _dio = DioService.instance.dio;

  @override
  Future<void> deleteUserAccount({required String userId}) async {
    try {
      await _dio.delete(
        ServerConfigurations.getRequestUrl(
            RoutesConstants.userRoutes.adminRoutes.deleteUser),
        data: {
          'userId': userId,
        },
      );
    } catch (e) {
      throw UnknownAdminUserException(message: e.toString());
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
          RoutesConstants.userRoutes.adminRoutes.getAllUsers,
        ),
        queryParameters: {
          'searchQuery': searchQuery,
          'page': page,
          'limit': limit,
        },
      );
      return response.dataOrThrow.map((e) => User.fromJson(e)).toList();
    } catch (e) {
      throw UnknownAdminUserException(message: e.toString());
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
          RoutesConstants.userRoutes.adminRoutes.sendNotificationToUser,
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
          'NOTIFICATION_SERVER_ERROR' => NotificationsServerAdminUserException(
              message: e.message.toString()),
          String() => UnknownAdminUserException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAdminUserException(message: e.message.toString());
    } catch (e) {
      throw UnknownAdminUserException(message: e.toString());
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
          RoutesConstants.userRoutes.adminRoutes.setAccountActivated,
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
          'ALREADY_ACTIVATED' => UserAlreadyNotActivatedAdminUserException(
              message: e.message.toString()),
          'ALREADY_NOT_ACTIVATED' => UserAlreadyNotActivatedAdminUserException(
              message: e.message.toString()),
          String() => UnknownAdminUserException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAdminUserException(message: e.message.toString());
    } catch (e) {
      throw UnknownAdminUserException(message: e.toString());
    }
  }
}
