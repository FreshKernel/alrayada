part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState({
    required this.userCredential,
  });

  final UserCredential? userCredential;

  UserCredential get requireUserCredential {
    return userCredential ??
        (throw StateError('You need to be authenticated.'));
  }

  @override
  List<Object?> get props => [userCredential];
}

final class UserInitial extends UserState {
  const UserInitial() : super(userCredential: null);
}

final class UserLoggedOut extends UserState {
  const UserLoggedOut() : super(userCredential: null);
}

final class UserLoggedIn extends UserState {
  const UserLoggedIn({required super.userCredential});
}

// Login screen

final class UserLoginInProgress extends UserState {
  const UserLoginInProgress() : super(userCredential: null);
}

final class UserLoginSuccess extends UserState {
  const UserLoginSuccess({required UserCredential userCredential})
      : super(userCredential: userCredential);
}

final class UserLoginFailure extends UserState {
  const UserLoginFailure(this.exception) : super(userCredential: null);

  final UserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// Forgot password screen

final class UserForgotPasswordInProgress extends UserState {
  const UserForgotPasswordInProgress() : super(userCredential: null);
}

final class UserForgotPasswordSuccess extends UserState {
  const UserForgotPasswordSuccess() : super(userCredential: null);
}

final class UserForgotPasswordFailure extends UserState {
  const UserForgotPasswordFailure(this.exception) : super(userCredential: null);

  final UserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// For usage in different screens (account page, verify email screen etc..)

final class UserFetchUserInProgress extends UserState {
  const UserFetchUserInProgress({required super.userCredential});
}

final class UserFetchUserSuccess extends UserState {
  const UserFetchUserSuccess({required super.userCredential});
}

final class UserFetchUserFailure extends UserState {
  const UserFetchUserFailure(this.exception, {required super.userCredential});

  final UserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// For verify email screen

final class UserResendEmailVerificationInProgress extends UserState {
  const UserResendEmailVerificationInProgress({required super.userCredential});
}

final class UserResendEmailVerificationSuccess extends UserState {
  const UserResendEmailVerificationSuccess({required super.userCredential});
}

final class UserResendEmailVerificationFailure extends UserState {
  const UserResendEmailVerificationFailure(
    this.exception, {
    required super.userCredential,
  });

  final UserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// For the social login

final class UserSocialLoginInProgress extends UserState {
  const UserSocialLoginInProgress() : super(userCredential: null);
}

final class UserSocialLoginAborted extends UserState {
  const UserSocialLoginAborted() : super(userCredential: null);
}

final class UserSocialLoginSuccess extends UserState {
  const UserSocialLoginSuccess({required super.userCredential});
}

final class UserSocialLoginFailure extends UserState {
  const UserSocialLoginFailure(this.exception) : super(userCredential: null);

  final UserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// For deleting the user

final class UserDeleteInProgress extends UserState {
  const UserDeleteInProgress({required super.userCredential});
}

final class UserDeleteSuccess extends UserState {
  const UserDeleteSuccess() : super(userCredential: null);
}

final class UserDeleteFailure extends UserState {
  const UserDeleteFailure(this.exception, {required super.userCredential});

  final UserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// For Updating the user

final class UserUpdateUserInProgress extends UserState {
  const UserUpdateUserInProgress({required super.userCredential});
}

final class UserUpdateUserSuccess extends UserState {
  const UserUpdateUserSuccess({required super.userCredential});
}

final class UserUpdateUserFailure extends UserState {
  const UserUpdateUserFailure(this.exception, {required super.userCredential});

  final UserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}
