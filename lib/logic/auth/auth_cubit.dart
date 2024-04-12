import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../data/user/auth_exceptions.dart';
import '../../data/user/auth_repository.dart';
import '../../data/user/auth_social_login.dart';
import '../../data/user/models/auth_credential.dart';
import '../../data/user/models/user.dart';
import '../../utils/app_logger.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepository}) : super(const AuthInitial()) {
    fetchSavedUser();
  }
  final AuthRepository authRepository;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      emit(const AuthLoginInProgress());
      final userCredential = await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthLoginSuccess(userCredential: userCredential));
    } on AuthException catch (e) {
      emit(AuthLoginFailure(e));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserInfo userInfo,
  }) async {
    try {
      emit(const AuthLoginInProgress());
      final userCredential = await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        userInfo: userInfo,
      );
      emit(AuthLoginSuccess(userCredential: userCredential));
    } on AuthException catch (e) {
      emit(AuthLoginFailure(e));
    }
  }

  static const String socialLoginDisplayNamePrefKey = 'socialLoginDisplayName';

  Future<void> loginWithGoogle() async {
    try {
      emit(const AuthSocialLoginInProgress());
      final googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'profile',
        ],
      );
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // User abort the sign in process
        emit(const AuthSocialLoginAborted());
        return;
      }
      final googleAuth = await googleUser.authentication;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        socialLoginDisplayNamePrefKey,
        googleUser.displayName ?? '',
      );

      authenticateWithSocialLogin(
        GoogleSocialLogin(
          idToken: googleAuth.idToken ??
              (throw const InvalidSocialInfoAuthException(
                  message: 'The google id token should not be null')),
          accessToken: googleAuth.accessToken ??
              (throw const InvalidSocialInfoAuthException(
                  message: 'The google access token should not be null')),
        ),
        userInfo: null,
      );
    } on PlatformException catch (e) {
      emit(
        AuthSocialLoginFailure(
          UnknownAuthException(message: e.message.toString()),
        ),
      );
    } on Exception catch (e) {
      emit(
        AuthSocialLoginFailure(
          UnknownAuthException(message: e.toString()),
        ),
      );
    }
  }

  Future<void> loginWithApple() async {
    try {
      emit(const AuthSocialLoginInProgress());
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        socialLoginDisplayNamePrefKey,
        credential.givenName != null
            ? ('${credential.givenName} ${credential.familyName}')
            : '',
      );
      authenticateWithSocialLogin(
        AppleSocialLogin(
          identityToken: credential.identityToken ??
              (throw const InvalidSocialInfoAuthException(
                  message: 'The apple identity token should not be null')),
          authorizationCode: credential.authorizationCode,
          userIdentifier: credential.userIdentifier ??
              (throw const InvalidSocialInfoAuthException(
                  message: 'The apple user identifier should not be null')),
        ),
        userInfo: null,
      );
    } on SignInWithAppleException catch (e) {
      // TODO: emit the [AuthSocialLoginAborted]
      if (e is SignInWithAppleAuthorizationException) {
        // TODO: Test and remove this later
        AppLogger.info('Sign in with apple result is ${e.code}');
        switch (e.code) {
          case AuthorizationErrorCode.canceled:
            emit(const AuthSocialLoginAborted());
            break;
          case AuthorizationErrorCode.failed:
            rethrow;
          case AuthorizationErrorCode.invalidResponse:
            rethrow;
          case AuthorizationErrorCode.notHandled:
            rethrow;
          case AuthorizationErrorCode.notInteractive:
            return;
          case AuthorizationErrorCode.unknown:
            rethrow;
        }
      }
      AppLogger.error(
        'Error in sign in with apple: ${e.toString()} ${e.runtimeType}',
      );
    } on PlatformException catch (e) {
      emit(
        AuthSocialLoginFailure(
          UnknownAuthException(message: e.message.toString()),
        ),
      );
    } on Exception catch (e) {
      emit(
        AuthSocialLoginFailure(
          UnknownAuthException(message: e.toString()),
        ),
      );
    }
  }

  Future<void> authenticateWithSocialLogin(
    SocialLogin socialLogin, {
    /// Initially this will be null, but when the server tell us the user doesn't
    /// exists and we need to provide sign up data then we will pass a value
    required UserInfo? userInfo,
  }) async {
    try {
      // Make sure we are in the in progress state
      // will be useful when we request the user to enter the data and re-try again
      emit(const AuthSocialLoginInProgress());
      final userCredential = await authRepository.authenticateWithSocialLogin(
        socialLogin,
        userInfo: userInfo,
      );
      emit(AuthSocialLoginSuccess(userCredential: userCredential));
    } on AuthException catch (e) {
      emit(AuthSocialLoginFailure(e));
    }
  }

  Future<void> fetchSavedUser() async {
    try {
      final userCredential = await authRepository.fetchSavedUserCredential();
      if (userCredential == null) {
        emit(const AuthLoggedOut());
        return;
      }
      emit(AuthLoggedIn(userCredential: userCredential));
    } on AuthException catch (e) {
      // TODO: Handle this error
      AppLogger.error(
        'Unknown error while fetching the saved user: ${e.message}',
        error: e,
      );
      emit(const AuthLoggedOut());
    }
  }

  Future<void> fetchUser() async {
    final savedUserCredential = await authRepository.fetchSavedUserCredential();
    if (savedUserCredential == null) {
      throw StateError(
        'The user needs to be logged in in order to fetch the user',
      );
    }
    try {
      emit(AuthFetchUserInProgress(userCredential: savedUserCredential));
      final user = await authRepository.fetchUser();
      if (user == null) {
        // For the current impl of auth repository, we don't need to logout (clear the tokens etc..)
        // we only need to update the state but we will do it just in case
        await logout();
        return;
      }
      emit(AuthFetchUserSuccess(
        userCredential: savedUserCredential.copyWith(user: user),
      ));
    } on AuthException catch (e) {
      emit(AuthFetchUserFailure(e, userCredential: savedUserCredential));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      emit(const AuthLoggedOut());
    } catch (e) {
      // TODO: Handle this error
      AppLogger.error(
        'Unknown error while logging out: ${e.toString()}',
        error: e,
      );
    }
  }

  Future<void> updateUserInfo(
    UserInfo userInfo,
  ) async {
    try {
      emit(AuthUpdateUserInProgress(userCredential: state.userCredential));
      await authRepository.updateUserInfo(userInfo);
      emit(
        AuthUpdateUserSuccess(
          userCredential: state.requireUserCredential.copyWith(
            user: state.requireUserCredential.user.copyWith(
              info: userInfo,
            ),
          ),
        ),
      );
    } on AuthException catch (e) {
      emit(AuthUpdateUserFailure(e, userCredential: state.userCredential));
    }
  }

  /// For forgot password screen
  Future<void> sendResetPasswordLink({required String email}) async {
    try {
      emit(const AuthForgotPasswordInProgress());
      await authRepository.sendResetPasswordLink(email: email);
      emit(const AuthForgotPasswordSuccess());
    } on AuthException catch (e) {
      emit(AuthForgotPasswordFailure(e));
    }
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      emit(AuthResendEmailVerificationInProgress(
        userCredential: state.userCredential,
      ));
      await authRepository.sendEmailVerificationLink();
      emit(
        AuthResendEmailVerificationSuccess(
            userCredential: state.userCredential),
      );
    } on AuthException catch (e) {
      emit(AuthResendEmailVerificationFailure(
        e,
        userCredential: state.userCredential,
      ));
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(AuthDeleteInProgress(userCredential: state.userCredential));
      await authRepository.deleteAccount();
      // No need to logout as it do that internally by clearing the local data
      emit(const AuthDeleteSuccess());
    } on AuthException catch (e) {
      emit(AuthDeleteFailure(e, userCredential: state.userCredential));
    }
  }
}
