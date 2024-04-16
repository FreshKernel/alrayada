import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../data/user/models/auth_credential.dart';
import '../../data/user/models/user.dart';
import '../../data/user/user_exceptions.dart';
import '../../data/user/user_repository.dart';
import '../../data/user/user_social_login.dart';
import '../../utils/app_logger.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.userRepository}) : super(const UserInitial()) {
    fetchSavedUser();
  }
  final UserRepository userRepository;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      emit(const UserLoginInProgress());
      final userCredential = await userRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(UserLoginSuccess(userCredential: userCredential));
    } on UserException catch (e) {
      emit(UserLoginFailure(e));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserInfo userInfo,
  }) async {
    try {
      emit(const UserLoginInProgress());
      final userCredential = await userRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        userInfo: userInfo,
      );
      emit(UserLoginSuccess(userCredential: userCredential));
    } on UserException catch (e) {
      emit(UserLoginFailure(e));
    }
  }

  static const String socialLoginDisplayNamePrefKey = 'socialLoginDisplayName';

  Future<void> loginWithGoogle() async {
    try {
      emit(const UserSocialLoginInProgress());
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
        emit(const UserSocialLoginAborted());
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
              (throw const InvalidSocialInfoUserException(
                  message: 'The google id token should not be null')),
          accessToken: googleAuth.accessToken ??
              (throw const InvalidSocialInfoUserException(
                  message: 'The google access token should not be null')),
        ),
        userInfo: null,
      );
    } on PlatformException catch (e) {
      emit(
        UserSocialLoginFailure(
          UnknownUserException(message: e.message.toString()),
        ),
      );
    } on Exception catch (e) {
      emit(
        UserSocialLoginFailure(
          UnknownUserException(message: e.toString()),
        ),
      );
    }
  }

  Future<void> loginWithApple() async {
    try {
      emit(const UserSocialLoginInProgress());
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
              (throw const InvalidSocialInfoUserException(
                  message: 'The apple identity token should not be null')),
          authorizationCode: credential.authorizationCode,
          userIdentifier: credential.userIdentifier ??
              (throw const InvalidSocialInfoUserException(
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
            emit(const UserSocialLoginAborted());
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
        UserSocialLoginFailure(
          UnknownUserException(message: e.message.toString()),
        ),
      );
    } on Exception catch (e) {
      emit(
        UserSocialLoginFailure(
          UnknownUserException(message: e.toString()),
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
      emit(const UserSocialLoginInProgress());
      final userCredential = await userRepository.authenticateWithSocialLogin(
        socialLogin,
        userInfo: userInfo,
      );
      emit(UserSocialLoginSuccess(userCredential: userCredential));
    } on UserException catch (e) {
      emit(UserSocialLoginFailure(e));
    }
  }

  Future<void> fetchSavedUser() async {
    try {
      final userCredential = await userRepository.fetchSavedUserCredential();
      if (userCredential == null) {
        emit(const UserLoggedOut());
        return;
      }
      emit(UserLoggedIn(userCredential: userCredential));
    } on UserException catch (e) {
      // TODO: Handle this error
      AppLogger.error(
        'Unknown error while fetching the saved user: ${e.message}',
        error: e,
      );
      emit(const UserLoggedOut());
    }
  }

  Future<void> fetchUser() async {
    final savedUserCredential = await userRepository.fetchSavedUserCredential();
    if (savedUserCredential == null) {
      throw StateError(
        'The user needs to be logged in in order to fetch the user',
      );
    }
    try {
      emit(UserFetchUserInProgress(userCredential: savedUserCredential));
      final user = await userRepository.fetchUser();
      if (user == null) {
        // For the current impl of auth repository, we don't need to logout (clear the tokens etc..)
        // we only need to update the state but we will do it just in case
        await logout();
        return;
      }
      emit(UserFetchUserSuccess(
        userCredential: savedUserCredential.copyWith(user: user),
      ));
    } on UserException catch (e) {
      emit(UserFetchUserFailure(e, userCredential: savedUserCredential));
    }
  }

  Future<void> logout() async {
    try {
      await userRepository.logout();
      emit(const UserLoggedOut());
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
      emit(UserUpdateUserInProgress(userCredential: state.userCredential));
      await userRepository.updateUserInfo(userInfo);
      emit(
        UserUpdateUserSuccess(
          userCredential: state.requireUserCredential.copyWith(
            user: state.requireUserCredential.user.copyWith(
              info: userInfo,
            ),
          ),
        ),
      );
    } on UserException catch (e) {
      emit(UserUpdateUserFailure(e, userCredential: state.userCredential));
    }
  }

  /// For forgot password screen
  Future<void> sendResetPasswordLink({required String email}) async {
    try {
      emit(const UserForgotPasswordInProgress());
      await userRepository.sendResetPasswordLink(email: email);
      emit(const UserForgotPasswordSuccess());
    } on UserException catch (e) {
      emit(UserForgotPasswordFailure(e));
    }
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      emit(UserResendEmailVerificationInProgress(
        userCredential: state.userCredential,
      ));
      await userRepository.sendEmailVerificationLink();
      emit(
        UserResendEmailVerificationSuccess(
            userCredential: state.userCredential),
      );
    } on UserException catch (e) {
      emit(UserResendEmailVerificationFailure(
        e,
        userCredential: state.userCredential,
      ));
    }
  }

  Future<void> deleteAccount() async {
    try {
      emit(UserDeleteInProgress(userCredential: state.userCredential));
      await userRepository.deleteAccount();
      // No need to logout as it do that internally by clearing the local data
      emit(const UserDeleteSuccess());
    } on UserException catch (e) {
      emit(UserDeleteFailure(e, userCredential: state.userCredential));
    }
  }
}
