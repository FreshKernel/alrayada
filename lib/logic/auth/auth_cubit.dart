import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> authenticateWithGoogle({required UserInfo? userInfo}) async {
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

      final userCredential = await authRepository.authenticateWithSocialLogin(
        GoogleSocialLogin(
          // TODO: This needs to be updated, this exception has nothing to do with the error
          idToken: googleAuth.idToken ??
              (throw const OperationNotAllowedAuthException(
                  message: 'The google id token should not be null')),
          accessToken: googleAuth.accessToken ??
              (throw const OperationNotAllowedAuthException(
                  message: 'The google access token should not be null')),
        ),
        userInfo: userInfo,
      );
      if (!userCredential.user.isEmailVerified) {
        await authRepository.sendEmailVerificationLink();
      }
      emit(AuthSocialLoginSuccess(userCredential: userCredential));
    } on PlatformException catch (e) {
      emit(
        AuthSocialLoginFailure(
          UnknownAuthException(message: e.message.toString()),
        ),
      );
    } on AuthException catch (e) {
      emit(
        AuthSocialLoginFailure(e),
      );
    }
  }

  Future<void> authenticateWithApple({required UserInfo? userInfo}) async {
    try {
      emit(const AuthSocialLoginInProgress());
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final userCredential = await authRepository.authenticateWithSocialLogin(
        AppleSocialLogin(
          // TODO: This needs to be updated, handle exception in ui
          identityToken: credential.identityToken ??
              (throw StateError('The apple identity token should not be null')),
          authorizationCode: credential.authorizationCode,
          userIdentifier: credential.userIdentifier ??
              (throw StateError(
                  'The apple user identifier should not be null')),
        ),
        userInfo: userInfo,
      );
      if (!userCredential.user.isEmailVerified) {
        await authRepository.sendEmailVerificationLink();
      }
      emit(AuthSocialLoginSuccess(userCredential: userCredential));
    } on SignInWithAppleException catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
        // TODO: Test and remove this later
        AppLogger.info('Sign in with apple result is ${e.code}');
        switch (e.code) {
          case AuthorizationErrorCode.canceled:
            return;
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
      rethrow;
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
      print(e);
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
      // TODO: Needs to be tested in the verify email screen
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
    }
  }

  // Future<void> updateUserInfo(
  //   UserInfo userInfo,
  // ) async {
  //   final userCredential = state.userCredential;
  //   if (userCredential == null) {
  //     return;
  //   }
  //   try {
  //     await authRepository.updateUserInfo(userInfo);
  //     emit(
  //       state.copyWith(
  //         userCredential: userCredential.copyWith(
  //           user: userCredential.user.copyWith(
  //             info: userInfo,
  //           ),
  //         ),
  //       ),
  //     );
  //   } on AuthException catch (e) {
  //     emit(state.copyWith(exception: e));
  //   }
  // }

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
    final savedUserCredential = await authRepository.fetchSavedUserCredential();
    try {
      emit(AuthResendEmailVerificationInProgress(
        userCredential: savedUserCredential,
      ));
      await authRepository.sendEmailVerificationLink();
      emit(
        AuthResendEmailVerificationSuccess(userCredential: savedUserCredential),
      );
    } on AuthException catch (e) {
      emit(AuthResendEmailVerificationFailure(
        e,
        userCredential: savedUserCredential,
      ));
    }
  }
}
