import 'package:meta/meta.dart';

import 'auth_social_login.dart';

@immutable
sealed class AuthException implements Exception {
  const AuthException({
    required this.message,
  });
  final String message;

  @override
  String toString() => message;
}

// Sign In

class EmailNotFoundAuthException extends AuthException {
  const EmailNotFoundAuthException({required super.message});
}

class InvalidCredentialsAuthException extends AuthException {
  const InvalidCredentialsAuthException({required super.message});
}

class WrongPasswordAuthException extends AuthException {
  const WrongPasswordAuthException({required super.message});
}

// Sign Up

class EmailAlreadyUsedAuthException extends AuthException {
  const EmailAlreadyUsedAuthException({required super.message});
}

class EmailVerificationLinkAlreadySentAuthException extends AuthException {
  const EmailVerificationLinkAlreadySentAuthException({
    required super.message,
    required this.minutesToExpire,
  });

  final int minutesToExpire;
}

class ResetPasswordLinkAlreadySentAuthException extends AuthException {
  const ResetPasswordLinkAlreadySentAuthException({
    required super.message,
    required this.minutesToExpire,
  });

  final int minutesToExpire;
}

class EmailAlreadyVerifiedAuthException extends AuthException {
  const EmailAlreadyVerifiedAuthException({required super.message});
}

class UnknownAuthException extends AuthException {
  const UnknownAuthException({required super.message});
}

class EmailNeedsVerificationAuthException extends AuthException {
  const EmailNeedsVerificationAuthException({required super.message});
}

class TooManyRequestsAuthException extends AuthException {
  const TooManyRequestsAuthException({required super.message});
}

class UserDisabledAuthException extends AuthException {
  const UserDisabledAuthException({required super.message});
}

class NetworkAuthException extends AuthException {
  const NetworkAuthException({required super.message});
}

class OperationNotAllowedAuthException extends AuthException {
  const OperationNotAllowedAuthException({required super.message});
}

class UserNotLoggedInAnyMoreAuthException extends AuthException {
  const UserNotLoggedInAnyMoreAuthException({required super.message});
}

class InvalidSocialInfoAuthException extends AuthException {
  const InvalidSocialInfoAuthException({required super.message});
}

class SocialEmailIsNotVerifiedAuthException extends AuthException {
  const SocialEmailIsNotVerifiedAuthException({required super.message});
}

class SocialMissingSignUpDataAuthException extends AuthException {
  const SocialMissingSignUpDataAuthException({
    required super.message,
    required this.socialLogin,
  });

  /// When handle this exception, will request the sign up data then use this
  /// and send the request to the server once again.
  final SocialLogin socialLogin;
}
