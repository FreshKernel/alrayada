// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import '../user/models/user.dart';

part 'social_authentication.g.dart';

enum SocialAuthenticationProvider {
  google('Google'),
  apple('Apple');

  const SocialAuthenticationProvider(this.value);

  final String value;
}

@JsonSerializable(explicitToJson: true, createToJson: false)
@immutable
class SocialAuthentication {
  const SocialAuthentication({
    required this.deviceToken,
    required this.provider,
    this.signUpUserData,
  });

  factory SocialAuthentication.fromJson(Map<String, dynamic> json) =>
      _$SocialAuthenticationFromJson(json);
  final UserData? signUpUserData;
  final UserDeviceNotificationsToken deviceToken;
  final SocialAuthenticationProvider provider;

  Map<String, dynamic> toJson() {
    if (this is GoogleAuthentication) {
      return (this as GoogleAuthentication).toJson();
    } else if (this is AppleAuthentication) {
      return (this as AppleAuthentication).toJson();
    } else {
      throw Exception('Unsupported toJson()');
    }
  }

  SocialAuthentication copyWith({
    UserData? signUpUserData,
    UserDeviceNotificationsToken? deviceToken,
    SocialAuthenticationProvider? provider,
  }) {
    return SocialAuthentication(
      signUpUserData: signUpUserData ?? this.signUpUserData,
      deviceToken: deviceToken ?? this.deviceToken,
      provider: provider ?? this.provider,
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GoogleAuthentication extends SocialAuthentication {
  const GoogleAuthentication(
    this.idToken,
    UserData? signUpUserData,
    UserDeviceNotificationsToken deviceToken,
  ) : super(
          signUpUserData: signUpUserData,
          deviceToken: deviceToken,
          provider: SocialAuthenticationProvider.google,
        );

  factory GoogleAuthentication.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthenticationFromJson(json);

  final String idToken;

  @override
  Map<String, dynamic> toJson() => _$GoogleAuthenticationToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AppleAuthentication extends SocialAuthentication {
  const AppleAuthentication(
    this.identityToken,
    this.userId,
    UserData? signUpUserData,
    UserDeviceNotificationsToken deviceToken,
  ) : super(
          signUpUserData: signUpUserData,
          deviceToken: deviceToken,
          provider: SocialAuthenticationProvider.apple,
        );

  factory AppleAuthentication.fromJson(Map<String, dynamic> json) =>
      _$AppleAuthenticationFromJson(json);

  final String identityToken;
  final String userId;

  @override
  Map<String, dynamic> toJson() => _$AppleAuthenticationToJson(this);
}
