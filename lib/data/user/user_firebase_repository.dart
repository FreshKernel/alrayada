// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase;

// import '../../services/notifications/s_notifications.dart';
// import 'auth_custom_provider.dart';
// import 'auth_exceptions.dart';
// import 'auth_repository.dart';
// import 'models/auth_credential.dart';
// import 'models/user.dart';

// class FirebaseAuthRepository extends UserRepository {
//   final users = FirebaseFirestore.instance.collection('users');

//   @override
//   Future<UserCredential> authenticateWithCustomProvider(
//       AuthCustomProvider authCustomProvider) {
//     // TODO: implement authenticateWithCustomProvider
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> deleteAccount() async {
//     final user = firebase.FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       await firebase.FirebaseAuth.instance.currentUser?.delete();
//       await users.doc(user.uid).delete();
//     }
//   }

//   @override
//   Future<UserCredential?> fetchSavedUserCredential() async {
//     try {
//       final user = firebase.FirebaseAuth.instance.currentUser;
//       if (user == null) return null;

//       final userDocumentData = (await users.doc(user.uid).get()).data();
//       if (userDocumentData == null) return null;
//       return user.toUserCredential(userDocumentData);
//     } catch (e) {
//       throw UnknownAuthException(message: e.toString());
//     }
//   }

//   @override
//   Future<User?> fetchUser() async {
//     try {
//       final user = firebase.FirebaseAuth.instance.currentUser;
//       if (user == null) return null;

//       final userDocumentData = (await users.doc(user.uid).get()).data();
//       if (userDocumentData == null) return null;
//       return user.toUser(userDocumentData);
//     } catch (e) {
//       throw UnknownAuthException(message: e.toString());
//     }
//   }

//   @override
//   Future<void> sendResetPasswordLink({required String email}) async {
//     try {
//       await firebase.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
//     } on firebase.FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'user-not-found':
//           throw UserNotFoundAuthException(message: e.code);
//         default:
//           throw UnknownAuthException(message: e.toString());
//       }
//     }
//   }

//   @override
//   Future<void> logout() async {
//     await firebase.FirebaseAuth.instance.signOut();
//   }

//   @override
//   Future<void> sendEmailVerification() async {
//     try {
//       firebase.FirebaseAuth.instance.currentUser?.sendEmailVerification();
//     } on firebase.FirebaseAuthException catch (e) {
//       switch (e) {
//         default:
//           throw UnknownAuthException(message: e.toString());
//       }
//     }
//   }

//   @override
//   Future<UserCredential> signInWithEmailAndPassword(
//       {required String email, required String password}) async {
//     try {
//       final firebaseUserCredential =
//           await firebase.FirebaseAuth.instance.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final userDocumentData =
//           (await users.doc(firebaseUserCredential.user?.uid).get()).data();
//       if (userDocumentData == null) {
//         throw const UnknownAuthException(
//           message: 'The firestore data has been deleted',
//         );
//       }
//       final firebaseUser = firebaseUserCredential.user;
//       if (firebaseUser == null) {
//         throw const UnknownAuthException(
//             message: 'User is still null after successfull login');
//       }
//       return await firebaseUser.toUserCredential(userDocumentData);
//     } on firebase.FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'user-not-found':
//           throw UserNotFoundAuthException(message: e.toString());
//         case 'operation-not-allowed':
//           throw OperationNotAllowedAuthException(
//             message: 'This login provider is disabled: ${e.toString()}',
//           );
//         case 'wrong-password':
//           throw WrongPasswordAUthException(message: e.toString());
//         case 'INVALID_LOGIN_CREDENTIALS':
//         case 'invalid-credential':
//           throw InvalidCredentialsAuthException(message: e.toString());
//         case 'user-disabled':
//           throw UserDisabledAuthException(message: e.toString());
//         case 'too-many-requests':
//           throw TooManyRequestsAuthException(message: e.toString());
//         case 'network-request-failed':
//           throw NetworkAuthException(message: e.toString());

//         default:
//           throw UnknownAuthException(message: e.toString());
//       }
//     }
//   }

//   @override
//   Future<UserCredential> signUpWithEmailAndPassword({
//     required String email,
//     required String password,
//     required UserData userData,
//   }) async {
//     try {
//       final firebaseUserCredential =
//           await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       final userDocumentData = await FirebaseUserExt.toJson(userData: userData);

//       await users.doc(firebaseUserCredential.user?.uid).set(userDocumentData);
//       final firebaseUser = firebaseUserCredential.user;
//       if (firebaseUser == null) {
//         throw const UnknownAuthException(
//             message: 'User is still null after successfull login');
//       }
//       return await firebaseUser.toUserCredential(userDocumentData);
//     } on firebase.FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'email-already-in-use':
//           throw EmailAlreadyUsedAuthException(message: e.toString());
//         case 'user-not-found':
//           throw UserNotFoundAuthException(message: e.toString());
//         case 'operation-not-allowed':
//           throw OperationNotAllowedAuthException(
//             message: 'This login provider is disabled: ${e.toString()}',
//           );
//         case 'wrong-password':
//           throw WrongPasswordAUthException(message: e.toString());
//         case 'INVALID_LOGIN_CREDENTIALS':
//         case 'invalid-credential':
//           throw InvalidCredentialsAuthException(message: e.toString());
//         case 'user-disabled':
//           throw UserDisabledAuthException(message: e.toString());
//         case 'too-many-requests':
//           throw TooManyRequestsAuthException(message: e.toString());
//         case 'network-request-failed':
//           throw NetworkAuthException(message: e.toString());

//         default:
//           throw UnknownAuthException(message: e.toString());
//       }
//     }
//   }

//   @override
//   Future<void> updateDeviceToken() async {}

//   @override
//   Future<void> updateUserData(UserData userData) async {
//     await users.doc(firebase.FirebaseAuth.instance.currentUser?.uid).update({
//       'data': userData.toJson(),
//     });
//   }

//   @override
//   Future<void> updateUserPassword({
//     required String currentPassword,
//     required String newPassword,
//   }) async {
//     try {
//       final user = firebase.FirebaseAuth.instance.currentUser;
//       if (user == null) return;
//       final credential = firebase.EmailAuthProvider.credential(
//         email: user.email ?? '',
//         password: currentPassword,
//       );
//       final newUserCredential = await user.reauthenticateWithCredential(
//         credential,
//       );
//       await newUserCredential.user?.updatePassword(newPassword);
//     } on firebase.FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'invalid-credential':
//         case 'wrong-password':
//           throw InvalidCredentialsAuthException(message: e.toString());
//         case 'user-not-found':
//           throw UserNotFoundAuthException(message: e.toString());
//         default:
//           throw UnknownAuthException(message: e.toString());
//       }
//     }
//   }
// }

// extension FirebaseUserExt on firebase.User {
//   Future<UserCredential> toUserCredential(
//     Map<String, dynamic> userDocumentData,
//   ) async {
//     return UserCredential(
//       accessToken: await getIdToken() ?? '',
//       refreshToken: refreshToken ?? '',
//       user: toUser(userDocumentData),
//     );
//   }

//   User toUser(Map<String, dynamic> userDocumentData) => User(
//         email: email ?? '',
//         data: UserData.fromJson(userDocumentData['data']),
//         userId: uid,
//         pictureUrl: photoURL,
//         isAccountVerified: userDocumentData['isAccountVerified'],
//         isEmailVerified: emailVerified,
//         role: UserRole.values
//             .firstWhere((rule) => userDocumentData['role'] == rule.name),
//         deviceNotificationsToken: UserDeviceNotificationsToken.fromJson(
//             userDocumentData['deviceNotificationsToken']),
//       );

//   static Future<Map<String, dynamic>> toJson(
//           {required UserData userData}) async =>
//       {
//         'deviceNotificationsToken':
//             (await NotificationsService.instanse.getUserDeviceToken()).toJson(),
//         'role': UserRole.user.name,
//         'isAccountVerified': false,
//         'data': userData.toJson(),
//       };
// }
