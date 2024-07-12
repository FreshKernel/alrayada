import 'package:meta/meta.dart';

@immutable
sealed class AdminUserException implements Exception {
  const AdminUserException({
    required this.message,
  });

  final String message;

  @override
  String toString() => message;
}

class UnknownAdminUserException extends AdminUserException {
  const UnknownAdminUserException({required super.message});
}

class UserAlreadyActivatedAdminUserException extends AdminUserException {
  const UserAlreadyActivatedAdminUserException({required super.message});
}

class UserAlreadyNotActivatedAdminUserException extends AdminUserException {
  const UserAlreadyNotActivatedAdminUserException({required super.message});
}

class NotificationsServerAdminUserException extends AdminUserException {
  const NotificationsServerAdminUserException({required super.message});
}
