import '../models/user.dart';

abstract class AdminUserApi {
  Future<List<User>> getAllUsers({
    required int page,
    required int limit,
    required String search,
  });
  Future<void> deleteUserAccount({required String userId});
  Future<void> setAccountActivated({
    required String userId,
    required bool value,
  });
  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
  });
}
