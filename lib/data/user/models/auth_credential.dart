import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'auth_credential.freezed.dart';
part 'auth_credential.g.dart';

@freezed
class UserCredential with _$UserCredential {
  const factory UserCredential({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) = _UserCredential;

  factory UserCredential.fromJson(Map<String, dynamic> json) =>
      _$UserCredentialFromJson(json);
}
