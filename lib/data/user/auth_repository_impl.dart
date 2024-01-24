import 'dart:async' show Timer;
import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage, AndroidOptions;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/dio_service.dart';
import '../../services/notifications/s_notifications.dart';
import '../../utils/constants/routes_constants.dart';
import '../../utils/server.dart';
import 'auth_custom_provider.dart';
import 'auth_exceptions.dart';
import 'auth_repository.dart';
import 'models/auth_credential.dart';
import 'models/user.dart';

class AuthRepositoryImpl extends AuthRepository {
  final _dio = DioService.instance.dio;
  final _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.signIn,
        ),
        data: {
          'email': email,
          'password': password,
          'deviceToken':
              (await NotificationsService.instanse.getUserDeviceToken())
                  .toJson(),
        },
      );
      final userResponse = UserCredential.fromJson(jsonDecode(
        response.data.toString(),
      ));
      saveUser(userResponse);
      DioService.instance.setJwtToken(
        userResponse.accessToken,
        onInvalidToken: logout,
      );
      return userResponse;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw TooManyRequestsAuthException(message: e.message.toString());
      }
      final code = e.response?.data['code'].toString() ?? '';
      final exception = switch (code) {
        'EMAIL_USED' =>
          EmailAlreadyUsedAuthException(message: e.message.toString()),
        'USER_NOT_FOUND' =>
          UserNotFoundAuthException(message: e.message.toString()),
        'INVALID_CREDENTIALS' =>
          InvalidCredentialsAuthException(message: e.message.toString()),
        'VERIFICATION_LINK_ALREADY_SENT' =>
          VerificationLinkAlreadySentAuthException(
            message: e.message.toString(),
            minutesToExpire: int.parse(
                e.response?.data['data']['minutesToExpire'] as String),
          ),
        'UNKNOWN_ERROR' => UnknownAuthException(message: e.message.toString()),
        'EMAIL_VERIFICATION' =>
          EmailNeedsVerificationAuthException(message: e.message.toString()),
        String() => UnknownAuthException(message: e.message.toString()),
      };
      throw exception;
    } catch (e) {
      throw UnknownAuthException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserData userData,
  }) async {
    try {
      await _dio.post(
        ServerConfigurations.getRequestUrl(RoutesConstants.authRoutes.signUp),
        data: {
          'email': email,
          'password': password,
          'userData': userData.toJson(),
          'deviceToken':
              (await NotificationsService.instanse.getUserDeviceToken())
                  .toJson(),
        },
      );
      throw UnimplementedError();
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw TooManyRequestsAuthException(message: e.message.toString());
      }
      final code = e.response?.data['code'].toString() ?? '';
      final exception = switch (code) {
        'EMAIL_USED' =>
          EmailAlreadyUsedAuthException(message: e.message.toString()),
        'USER_NOT_FOUND' =>
          UserNotFoundAuthException(message: e.message.toString()),
        'INVALID_CREDENTIALS' =>
          InvalidCredentialsAuthException(message: e.message.toString()),
        'VERIFICATION_LINK_ALREADY_SENT' =>
          VerificationLinkAlreadySentAuthException(
            message: e.message.toString(),
            minutesToExpire: int.parse(
                e.response?.data['data']['minutesToExpire'] as String),
          ),
        String() => UnknownAuthException(message: e.message.toString()),
      };
      throw exception;
    } catch (e) {
      throw UnknownAuthException(
        message: e.toString(),
      );
    }
  }

  static const userPrefKey = 'user';
  static const jwtTokenPrefKey = 'jwtToken';

  Future<void> saveUser(
    UserCredential userCredential,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    // Don't save the token in shared prefs
    await prefs.setString(
      userPrefKey,
      jsonEncode(userCredential.copyWith(accessToken: '')),
    );
    await _secureStorage.write(
      key: jwtTokenPrefKey,
      value: userCredential.accessToken,
    );
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userPrefKey);
    await _secureStorage.delete(key: jwtTokenPrefKey);
    DioService.instance.clearJwtToken();
  }

  @override
  Future<UserCredential?> fetchSavedUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUserJson = prefs.getString('user');
    if (savedUserJson == null) return null;
    final jwt = await _secureStorage.read(key: jwtTokenPrefKey);
    if (jwt == null) return null;
    // Without Jwt
    final userCredential =
        UserCredential.fromJson(jsonDecode(savedUserJson)).copyWith(
      accessToken: jwt,
    );
    DioService.instance.setJwtToken(jwt, onInvalidToken: logout);
    return userCredential;
  }

  @override
  Future<User?> fetchUser() async {
    final response = await _dio.get(
      ServerConfigurations.getRequestUrl(RoutesConstants.authRoutes.user),
    );
    final responseData = response.data;
    if (responseData == null) return null;
    final user = User.fromJson(jsonDecode(responseData));
    return user;
  }

  @override
  Future<UserCredential> authenticateWithCustomProvider(
    AuthCustomProvider authCustomProvider,
  ) async {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAccount() async {
    final response = await _dio.delete(
      ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.deleteAccount),
    );
    if (response.statusCode != 200) {
      return;
    }
    await logout();
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await _dio.post(
      ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.forgotPassword),
      queryParameters: {
        'email': email,
      },
    );
  }

  @override
  Future<void> updateDeviceToken() async {
    await _dio.patch(
      ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.updateDeviceToken),
      data: (await NotificationsService.instanse.getUserDeviceToken()).toJson(),
    );
  }

  @override
  Future<void> updateUserData(
    UserData userData,
  ) async {
    await _dio.put(
      ServerConfigurations.getRequestUrl(RoutesConstants.authRoutes.userData),
      data: userData.toJson(),
    );
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(userPrefKey);
    if (json == null) return;
    final userAuthenticatedResponse = UserCredential.fromJson(jsonDecode(json));

    await saveUser(userAuthenticatedResponse.copyWith(
      user: userAuthenticatedResponse.user.copyWith(
        data: userData,
      ),
    ));
  }

  @override
  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.patch(
      ServerConfigurations.getRequestUrl(
        RoutesConstants.authRoutes.updatePassword,
      ),
      queryParameters: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<void> sendEmailVerification() {
    throw UnimplementedError();
  }
}
