import '../models/user.dart';

abstract class AdminAuthRepository {
  Future<List<User>> getAllUsers({
    required String searchQuery,
    required int page,
    required int limit,
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
