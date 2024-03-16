import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fresh_base_package/fresh_base_package.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../data/user/auth_custom_provider.dart';
import '../../data/user/auth_exceptions.dart';
import '../../data/user/auth_repository.dart';
import '../../data/user/models/auth_credential.dart';
import '../../data/user/models/user.dart';
import '../../utils/app_logger.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepository})
      : super(const AuthState(userCredential: null)) {
    fetchSavedUser();
  }
  final AuthRepository authRepository;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(state.copyWith(
        exception: null,
        userCredential: userCredential,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserInfo userInfo,
  }) async {
    try {
      final userCredential = await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        userInfo: userInfo,
      );
      emit(state.copyWith(
        exception: null,
        userCredential: userCredential,
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> authenticateWithGoogle() async {
    try {
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
      final googleAuth = await googleUser?.authentication;
      final userCredential =
          await authRepository.authenticateWithCustomProvider(
        GoogleAuthCustomProvider(
          idToken: googleAuth?.idToken,
          accessToken: googleAuth?.accessToken,
        ),
      );
      if (!userCredential.user.isEmailVerified) {
        await authRepository.sendEmailVerificationLink();
      }
      emit(state.copyWith(
        userCredential: userCredential,
        exception: null,
      ));
    } on PlatformException catch (e) {
      emit(
        state.copyWith(
          exception: UnknownAuthException(message: e.message.toString()),
        ),
      );
    } on AuthException catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> authenticateWithApple() async {
    try {
      final AuthCustomProvider authCustomProvider;
      final isAvaliable = await SignInWithApple.isAvailable();
      if (!isAvaliable) {
        AppLogger.error('Sign in with apple is not avaliable.');
        return;
      }
      if (!PlatformChecker.nativePlatform().isAppleSystem()) {
        authCustomProvider = const AppleAuthCustomProvider(
          identityToken: null,
          authorizationCode: null,
          userIdentifier: null,
        );
      } else {
        final credential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
        authCustomProvider = AppleAuthCustomProvider(
          identityToken: credential.identityToken,
          authorizationCode: credential.authorizationCode,
          userIdentifier: credential.userIdentifier,
        );
      }
      final userCredential = await authRepository
          .authenticateWithCustomProvider(authCustomProvider);
      if (!userCredential.user.isEmailVerified) {
        await authRepository.sendEmailVerificationLink();
      }
      emit(state.copyWith(
        userCredential: userCredential,
        exception: null,
      ));
    } on SignInWithAppleException catch (e) {
      if (e is SignInWithAppleAuthorizationException) {
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
      emit(state.copyWith(userCredential: userCredential));
    } on AuthException catch (e) {
      emit(state.copyWith(userCredential: null, exception: e));
    }
  }

  Future<void> fetchUser() async {
    try {
      final user = await authRepository.fetchUser();
      if (user == null) return;
      emit(state.copyWith(
        userCredential: state.userCredential?.copyWith(
          user: user,
        ),
        lastUpdate: DateTime.now().toIso8601String(),
      ));
    } on AuthException catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> logout() async {
    try {
      await authRepository.logout();
      emit(state.copyWith(userCredential: null));
    } on AuthException catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> updateUserInfo(
    UserInfo userInfo,
  ) async {
    final userCredential = state.userCredential;
    if (userCredential == null) {
      return;
    }
    try {
      await authRepository.updateUserInfo(userInfo);
      emit(
        state.copyWith(
          userCredential: userCredential.copyWith(
            user: userCredential.user.copyWith(
              info: userInfo,
            ),
          ),
        ),
      );
    } on AuthException catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> sendEmailVerificationLink() async {
    final userCredential = state.userCredential;
    if (userCredential == null) {
      return;
    }
    try {
      await authRepository.sendEmailVerificationLink();
    } on AuthException catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> sendResetPasswordLink({required String email}) async {
    try {
      await authRepository.sendResetPasswordLink(email: email);
    } on AuthException catch (e) {
      emit(state.copyWith(exception: e));
    }
  }
}
