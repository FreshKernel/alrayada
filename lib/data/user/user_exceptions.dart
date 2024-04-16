import 'package:meta/meta.dart';

import 'user_social_login.dart';

@immutable
sealed class UserException implements Exception {
  const UserException({
    required this.message,
  });
  final String message;

  @override
  String toString() => message;
}

// Sign In

class EmailNotFoundUserException extends UserException {
  const EmailNotFoundUserException({required super.message});
}

class InvalidCredentialsUserException extends UserException {
  const InvalidCredentialsUserException({required super.message});
}

class WrongPasswordUserException extends UserException {
  const WrongPasswordUserException({required super.message});
}

// Sign Up

class EmailAlreadyUsedUserException extends UserException {
  const EmailAlreadyUsedUserException({required super.message});
}

class EmailVerificationLinkAlreadySentUserException extends UserException {
  const EmailVerificationLinkAlreadySentUserException({
    required super.message,
    required this.minutesToExpire,
  });

  final int minutesToExpire;
}

class ResetPasswordLinkAlreadySentUserException extends UserException {
  const ResetPasswordLinkAlreadySentUserException({
    required super.message,
    required this.minutesToExpire,
  });

  final int minutesToExpire;
}

class EmailAlreadyVerifiedUserException extends UserException {
  const EmailAlreadyVerifiedUserException({required super.message});
}

class UnknownUserException extends UserException {
  const UnknownUserException({required super.message});
}

class EmailNeedsVerificationUserException extends UserException {
  const EmailNeedsVerificationUserException({required super.message});
}

class TooManyRequestsUserException extends UserException {
  const TooManyRequestsUserException({required super.message});
}

class UserDisabledUserException extends UserException {
  const UserDisabledUserException({required super.message});
}

class NetworkUserException extends UserException {
  const NetworkUserException({required super.message});
}

class OperationNotAllowedUserException extends UserException {
  const OperationNotAllowedUserException({required super.message});
}

class UserNotLoggedInAnyMoreUserException extends UserException {
  const UserNotLoggedInAnyMoreUserException({required super.message});
}

class InvalidSocialInfoUserException extends UserException {
  const InvalidSocialInfoUserException({required super.message});
}

class SocialEmailIsNotVerifiedUserException extends UserException {
  const SocialEmailIsNotVerifiedUserException({required super.message});
}

class SocialMissingSignUpDataUserException extends UserException {
  const SocialMissingSignUpDataUserException({
    required super.message,
    required this.socialLogin,
  });

  /// When handle this exception, will request the sign up data then use this
  /// and send the request to the server once again.
  final SocialLogin socialLogin;
}
