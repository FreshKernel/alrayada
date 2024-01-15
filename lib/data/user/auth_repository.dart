import 'auth_custom_provider.dart';
import 'models/auth_credential.dart';
import 'models/user.dart';

abstract class AuthRepository {
  Future<void> updateUserData(
    UserData userData,
  );
  Future<void> updateUserPassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> forgotPassword({
    required String email,
  });
  Future<void> logout();
  Future<void> updateDeviceToken();
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserData userData,
  });
  Future<UserCredential> authenticateWithCustomProvider(
    AuthCustomProvider authCustomProvider,
  );
  Future<void> deleteAccount();
  Future<UserCredential?> fetchSavedUser();
  Future<void> sendEmailVerification();
  Future<User?> fetchUser();
}
