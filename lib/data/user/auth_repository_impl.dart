import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage, AndroidOptions;
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/dio_service.dart';
import '../../services/notifications/s_notifications.dart';
import '../../utils/constants/routes_constants.dart';
import '../../utils/error_response.dart';
import '../../utils/server.dart';
import 'auth_exceptions.dart';
import 'auth_repository.dart';
import 'auth_social_login.dart';
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
          'deviceNotificationsToken':
              (await NotificationsService.instanse.getUserDeviceToken())
                  .toJson(),
        },
      );
      final userCredential = _handleAuthSuccessResponse(response.data);
      return userCredential;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw TooManyRequestsAuthException(message: e.message.toString());
      }
      final responseData = e.response?.data;
      if (responseData is Map) {
        final code = ErrorResponse.fromJson(responseData.cast()).code;
        final exception = switch (code) {
          'INVALID_CREDENTIALS' =>
            InvalidCredentialsAuthException(message: e.message.toString()),
          'EMAIL_NOT_FOUND' =>
            EmailNotFoundAuthException(message: e.message.toString()),
          'WRONG_PASSWORD' =>
            WrongPasswordAuthException(message: e.message.toString()),
          String() => UnknownAuthException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAuthException(message: e.message.toString());
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
    required UserInfo userInfo,
  }) async {
    try {
      final response = await _dio.post<Map<String, Object?>>(
        ServerConfigurations.getRequestUrl(RoutesConstants.authRoutes.signUp),
        data: {
          'email': email,
          'password': password,
          'userInfo': userInfo.toJson(),
          'deviceNotificationsToken':
              (await NotificationsService.instanse.getUserDeviceToken())
                  .toJson(),
        },
      );
      final userCredential = _handleAuthSuccessResponse(response.data);
      return userCredential;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw TooManyRequestsAuthException(message: e.message.toString());
      }
      final responseData = e.response?.data;
      if (responseData is Map) {
        final code = ErrorResponse.fromJson(responseData.cast()).code;
        final exception = switch (code) {
          'EMAIL_USED' =>
            EmailAlreadyUsedAuthException(message: e.message.toString()),
          String() => UnknownAuthException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAuthException(message: e.message.toString());
    } catch (e) {
      throw UnknownAuthException(
        message: e.toString(),
      );
    }
  }

  /// Shared code between sign in, sign up, and social login
  Future<UserCredential> _handleAuthSuccessResponse(
      Map<String, Object?>? data) async {
    final userCredential = UserCredential.fromJson(
      data ?? (throw StateError('The response data from the server is null')),
    );
    await saveUser(userCredential);
    DioService.instance.setToken(
      accessToken: userCredential.accessToken,
      refreshToken: userCredential.refreshToken,
      onInvalidToken: logout,
    );
    return userCredential;
  }

  static const userPrefKey = 'user';
  static const accessTokenPrefKey = 'accessToken';
  static const refreshTokenPrefKey = 'refreshToken';

  Future<void> saveUser(
    UserCredential userCredential,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Don't save the tokens in shared prefs
      await prefs.setString(
        userPrefKey,
        jsonEncode(userCredential.copyWith(
          accessToken: '',
          refreshToken: '',
        )),
      );
      await _secureStorage.write(
        key: accessTokenPrefKey,
        value: userCredential.accessToken,
      );

      await _secureStorage.write(
        key: refreshTokenPrefKey,
        value: userCredential.refreshToken,
      );
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(userPrefKey);
      await _secureStorage.delete(key: accessTokenPrefKey);
      await _secureStorage.delete(key: refreshTokenPrefKey);
      DioService.instance.clearTokens();
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<UserCredential?> fetchSavedUserCredential() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUserJson = prefs.getString(userPrefKey);
      if (savedUserJson == null) return null;
      final accessToken = await _secureStorage.read(key: accessTokenPrefKey);
      final refreshToken = await _secureStorage.read(key: refreshTokenPrefKey);
      if (accessToken == null || refreshToken == null) return null;
      // Without Jwt
      final userCredential =
          UserCredential.fromJson(jsonDecode(savedUserJson)).copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      DioService.instance.setToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        onInvalidToken: logout,
      );
      return userCredential;
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<User?> fetchUser() async {
    try {
      final response = await _dio.get<Map<String, Object?>>(
        ServerConfigurations.getRequestUrl(
            RoutesConstants.authRoutes.getUserData),
      );
      final responseData = response.data;
      if (responseData == null) return null;
      final user = User.fromJson(responseData);
      final savedUserCredential = await fetchSavedUserCredential() ??
          (throw StateError(
              'To load the user from server, user must be authenticated.'));
      await saveUser(savedUserCredential.copyWith(user: user));
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // The user is no longer authenticated
        return null;
      }
      throw UnknownAuthException(message: e.toString());
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<UserCredential> authenticateWithSocialLogin(
    SocialLogin socialLogin, {
    required UserInfo? userInfo,
  }) async {
    try {
      final provider = switch (socialLogin) {
        GoogleSocialLogin() => 'Google',
        AppleSocialLogin() => 'Apple',
      };
      final response = await _dio.post<Map<String, Object?>>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.socialLogin,
        ),
        data: {
          'socialLogin': socialLogin.toJson(),
          'userInfo': userInfo?.toJson(),
          'deviceNotificationsToken':
              (await NotificationsService.instanse.getUserDeviceToken())
                  .toJson(),
        },
        queryParameters: {
          'provider': provider,
        },
      );
      final userCredential = _handleAuthSuccessResponse(response.data);
      return userCredential;
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw TooManyRequestsAuthException(message: e.message.toString());
      }
      final responseData = e.response?.data;
      if (responseData is Map) {
        final code = ErrorResponse.fromJson(responseData.cast()).code;
        final exception = switch (code) {
          'INVALID_SOCIAL_INFO' =>
            InvalidSocialInfoAuthException(message: e.message.toString()),
          'SOCIAL_EMAIL_NOT_VERIFIED' => SocialEmailIsNotVerifiedAuthException(
              message: e.message.toString()),
          'SOCIAL_MISSING_SIGNUP_DATA' => SocialMissingSignUpDataAuthException(
              message: e.message.toString(),
              socialLogin: socialLogin,
            ),
          String() => UnknownAuthException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAuthException(message: e.message.toString());
    } catch (e) {
      throw UnknownAuthException(
        message: e.toString(),
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _dio.delete(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.deleteAccount,
        ),
      );
      await logout();
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<void> updateDeviceNotificationsToken() async {
    try {
      await _dio.patch(
        ServerConfigurations.getRequestUrl(
            RoutesConstants.authRoutes.updateDeviceNotificationsToken),
        data:
            (await NotificationsService.instanse.getUserDeviceToken()).toJson(),
      );
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<void> updateUserInfo(
    UserInfo userInfo,
  ) async {
    try {
      await _dio.patch(
        ServerConfigurations.getRequestUrl(
            RoutesConstants.authRoutes.updateUserInfo),
        data: userInfo.toJson(),
      );
      final userCredential = await fetchSavedUserCredential() ??
          (throw StateError(
              'The current saved user credential is null which should not be.'));

      await saveUser(userCredential.copyWith(
        user: userCredential.user.copyWith(
          info: userInfo,
        ),
      ));
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _dio.patch(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.updatePassword,
        ),
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<void> sendEmailVerificationLink() async {
    try {
      await _dio.post(ServerConfigurations.getRequestUrl(
          RoutesConstants.authRoutes.sendEmailVerificationLink));
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw TooManyRequestsAuthException(message: e.message.toString());
      }
      if (e.response?.statusCode == 401) {
        throw UserNotLoggedInAnyMoreAuthException(
          message: e.message.toString(),
        );
      }
      // TODO: See why ErrorResponse data property can't cast to Map<String, String> and only Map<String, dynamic>
      final responseData = e.response?.data;
      if (responseData is Map) {
        final errorResponse = ErrorResponse.fromJson(responseData.cast());
        final exception = switch (errorResponse.code) {
          'EMAIL_ALREADY_VERIFIED' => EmailAlreadyVerifiedAuthException(
              message:
                  'Account is already verified and you are trying to verify it again, state error, fore more info: ${e.message.toString()}'),
          'EMAIL_VERIFICATION_LINK_ALREADY_SENT' =>
            EmailVerificationLinkAlreadySentAuthException(
              message: e.message.toString(),
              minutesToExpire:
                  int.parse(errorResponse.data?['minutesToExpire'] as String),
            ),
          String() => UnknownAuthException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAuthException(message: e.message.toString());
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }

  @override
  Future<void> sendResetPasswordLink({required String email}) async {
    try {
      await _dio.post(
        ServerConfigurations.getRequestUrl(
            RoutesConstants.authRoutes.sendResetPasswordLink),
        data: {
          'email': email,
        },
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 429) {
        throw TooManyRequestsAuthException(message: e.message.toString());
      }
      final responseData = e.response?.data;
      if (responseData is Map) {
        final errorResponse = ErrorResponse.fromJson(responseData.cast());
        final exception = switch (errorResponse.code) {
          'EMAIL_NOT_FOUND' =>
            EmailNotFoundAuthException(message: e.message.toString()),
          'RESET_PASSWORD_LINK_ALREADY_SENT' =>
            ResetPasswordLinkAlreadySentAuthException(
              message: e.message.toString(),
              minutesToExpire:
                  int.parse(errorResponse.data?['minutesToExpire'] as String),
            ),
          String() => UnknownAuthException(message: e.message.toString()),
        };
        throw exception;
      }
      throw UnknownAuthException(message: e.message.toString());
    } catch (e) {
      throw UnknownAuthException(message: e.toString());
    }
  }
}
