part of 'auth_cubit.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    required UserCredential? userCredential,
    @Default(null) AuthException? exception,
    // Used as a workaround for trigger BlocListener everytime
    @Default(null) String? lastUpdate,
  }) = _UserState;
}
