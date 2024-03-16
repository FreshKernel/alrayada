import 'auth_custom_provider.dart';
import 'models/auth_credential.dart';
import 'models/user.dart';

abstract class AuthRepository {
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserInfo userInfo,
  });

  Future<UserCredential> authenticateWithCustomProvider(
    AuthCustomProvider authCustomProvider,
  );

  Future<void> updateUserInfo(
    UserInfo userInfo,
  );
  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> updateDeviceNotificationsToken();

  Future<void> sendResetPasswordLink({
    required String email,
  });
  Future<void> sendEmailVerificationLink();

  Future<void> logout();
  Future<void> deleteAccount();

  Future<UserCredential?> fetchSavedUserCredential();
  Future<User?> fetchUser();
}
