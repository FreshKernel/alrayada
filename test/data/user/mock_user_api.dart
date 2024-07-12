import 'package:alrayada/auth/data/models/auth_credential.dart';
import 'package:alrayada/auth/data/models/user.dart';
import 'package:alrayada/auth/data/user_api.dart';
import 'package:alrayada/auth/data/user_social_login.dart';

final mockUserCredential = UserCredential(
  accessToken: 'accessToken',
  refreshToken: 'refreshToken',
  user: User(
    email: 'email',
    info: UserInfo(
      labOwnerPhoneNumber: 'labOwnerPhoneNumber',
      labPhoneNumber: 'labPhoneNumber',
      labName: 'labName',
      labOwnerName: 'labOwnerName',
      city: IraqGovernorate.defaultCity,
    ),
    id: 'userId',
    pictureUrl: 'pictureUrl',
    isAccountActivated: false,
    isEmailVerified: false,
    role: UserRole.admin,
    deviceNotificationsToken:
        const UserDeviceNotificationsToken(firebase: '', oneSignal: 'dsadas'),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ),
);

class MockUserApi extends UserApi {
  @override
  Future<UserCredential> authenticateWithSocialLogin(SocialLogin socialLogin,
      {required UserInfo? userInfo}) async {
    return mockUserCredential;
  }

  @override
  Future<void> deleteAccount() async {}

  @override
  Future<UserCredential?> fetchSavedUserCredential() async {
    return mockUserCredential;
  }

  @override
  Future<User?> fetchUser() async {
    return mockUserCredential.user;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> sendEmailVerificationLink() async {}

  @override
  Future<void> sendResetPasswordLink({required String email}) async {}

  @override
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    return mockUserCredential;
  }

  @override
  Future<UserCredential> signUpWithEmailAndPassword(
      {required String email,
      required String password,
      required UserInfo userInfo}) async {
    return mockUserCredential;
  }

  @override
  Future<void> updateDeviceNotificationsToken() async {}

  @override
  Future<void> updateUserInfo(UserInfo userInfo) async {}

  @override
  Future<void> updateUserPassword(
      {required String currentPassword, required String newPassword}) async {}
}
