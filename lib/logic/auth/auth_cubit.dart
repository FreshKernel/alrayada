import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/social_authentication/social_authentication.dart';
import '../../data/user/auth_repository.dart';
import '../../data/user/models/auth_credential.dart';
import '../../data/user/models/user.dart';
import '../../services/notifications/s_notifications.dart';

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
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserData userData,
  }) async {
    try {
      await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
        userData: userData,
      );
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> authenticateWithSocialLogin(
      SocialAuthentication socialAuthentication) async {
    try {
      socialAuthentication = socialAuthentication.copyWith(
        deviceToken: await NotificationsService.instanse.getUserDeviceToken(),
      );
      final userCredential = await authRepository.authenticateWithSocialLogin(
        socialAuthentication,
      );
      emit(state.copyWith(
        exception: null,
        userCredential: userCredential,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(exception: e));
    }
  }

  Future<void> deleteAccount() async {
    try {
      await authRepository.deleteAccount();
      emit(
        state.copyWith(userCredential: null, exception: null),
      );
    } catch (e) {
      emit(state.copyWith(exception: null));
    }
  }

  Future<void> fetchSavedUser() async {
    try {
      final userCredential = await authRepository.fetchSavedUser();
      emit(state.copyWith(userCredential: userCredential));
      // ignore: empty_catches
    } catch (e) {}
  }

  Future<void> fetchUser() async {
    try {
      final user = await authRepository.fetchUser();
      if (user == null) return;
      emit(state.copyWith(
        userCredential: state.userCredential?.copyWith(
          user: user,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(userCredential: null, exception: null));
    }
  }

  Future<void> forgotPassword({required String email}) =>
      authRepository.forgotPassword(email: email);

  Future<void> logout() async {
    try {
      await authRepository.logout();
      emit(state.copyWith(userCredential: null));
    } catch (e) {
      emit(state.copyWith(exception: null));
    }
  }

  Future<void> updateDeviceToken() => authRepository.updateDeviceToken();

  Future<void> updateUserData(
    UserData userData,
  ) async {
    final userCredential = state.userCredential;
    if (userCredential == null) {
      return;
    }
    try {
      await authRepository.updateUserData(userData);
      emit(
        state.copyWith(
          userCredential: userCredential.copyWith(
            user: userCredential.user.copyWith(
              data: userData,
            ),
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(exception: null));
    }
  }

  Future<void> updateUserPassword(
          {required String currentPassword, required String newPassword}) =>
      authRepository.updateUserPassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
}
