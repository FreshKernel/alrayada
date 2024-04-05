import 'package:meta/meta.dart';

@immutable
sealed class AdminAuthException implements Exception {
  const AdminAuthException({
    required this.message,
  });

  final String message;

  @override
  String toString() => message;
}

class UnknownAdminAuthException extends AdminAuthException {
  const UnknownAdminAuthException({required super.message});
}

class UserAlreadyActivatedException extends AdminAuthException {
  const UserAlreadyActivatedException({required super.message});
}

class UserAlreadyNotActivatedException extends AdminAuthException {
  const UserAlreadyNotActivatedException({required super.message});
}

class NotificationsServerException extends AdminAuthException {
  const NotificationsServerException({required super.message});
}

// class UnauthorizedAccessAuthException extends AdminAuthException {
//   const UnauthorizedAccessAuthException({required super.message});
// }
