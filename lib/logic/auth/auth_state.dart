part of 'auth_cubit.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    required UserCredential? userCredential,
    @Default(null) AuthException? exception,
  }) = _UserState;
}
