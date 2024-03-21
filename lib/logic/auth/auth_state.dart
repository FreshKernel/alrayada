part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState({
    required this.userCredential,
  });

  final UserCredential? userCredential;

  @override
  List<Object?> get props => [userCredential];
}

final class AuthInitial extends AuthState {
  const AuthInitial() : super(userCredential: null);
}

final class AuthLoggedOut extends AuthState {
  const AuthLoggedOut() : super(userCredential: null);
}

final class AuthLoggedIn extends AuthState {
  const AuthLoggedIn({required super.userCredential});
}

// Login screen

final class AuthLoginInProgress extends AuthState {
  const AuthLoginInProgress() : super(userCredential: null);
}

final class AuthLoginSuccess extends AuthState {
  const AuthLoginSuccess({required UserCredential userCredential})
      : super(userCredential: userCredential);
}

final class AuthLoginFailure extends AuthState {
  const AuthLoginFailure(this.exception) : super(userCredential: null);

  final AuthException exception;

  @override
  List<Object?> get props => [userCredential, exception];
}

// Forgot password screen

final class AuthForgotPasswordInProgress extends AuthState {
  const AuthForgotPasswordInProgress() : super(userCredential: null);
}

final class AuthForgotPasswordSuccess extends AuthState {
  const AuthForgotPasswordSuccess() : super(userCredential: null);
}

final class AuthForgotPasswordFailure extends AuthState {
  const AuthForgotPasswordFailure(this.exception) : super(userCredential: null);

  final AuthException exception;

  @override
  List<Object?> get props => [userCredential, exception];
}

// For usage in different screens (account page, verify email screen etc..)

final class AuthFetchUserInProgress extends AuthState {
  const AuthFetchUserInProgress({required super.userCredential});
}

final class AuthFetchUserSuccess extends AuthState {
  const AuthFetchUserSuccess({required super.userCredential});
}

final class AuthFetchUserFailure extends AuthState {
  const AuthFetchUserFailure(this.exception, {required super.userCredential});

  final AuthException exception;

  @override
  List<Object?> get props => [userCredential, exception];
}

// For verify email screen

final class AuthResendEmailVerificationInProgress extends AuthState {
  const AuthResendEmailVerificationInProgress({required super.userCredential});
}

final class AuthResendEmailVerificationSuccess extends AuthState {
  const AuthResendEmailVerificationSuccess({required super.userCredential});
}

final class AuthResendEmailVerificationFailure extends AuthState {
  const AuthResendEmailVerificationFailure(this.exception,
      {required super.userCredential});

  final AuthException exception;

  @override
  List<Object?> get props => [userCredential, exception];
}

// For the social login

final class AuthSocialLoginInProgress extends AuthState {
  const AuthSocialLoginInProgress() : super(userCredential: null);
}

final class AuthSocialLoginAborted extends AuthState {
  const AuthSocialLoginAborted() : super(userCredential: null);
}

final class AuthSocialLoginSuccess extends AuthState {
  const AuthSocialLoginSuccess({required super.userCredential});
}

final class AuthSocialLoginFailure extends AuthState {
  const AuthSocialLoginFailure(this.exception) : super(userCredential: null);

  final AuthException exception;

  @override
  List<Object?> get props => [userCredential, exception];
}
