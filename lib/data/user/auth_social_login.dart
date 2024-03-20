import 'package:meta/meta.dart';

@immutable
sealed class SocialLogin {
  const SocialLogin({
    required this.providerId,
  });

  final String providerId;

  Map<String, Object?> toJson() {
    throw UnimplementedError('You are using the SocialLogin');
  }
}

final class GoogleSocialLogin extends SocialLogin {
  const GoogleSocialLogin({
    required this.idToken,
    required this.accessToken,
  }) : super(
          providerId: 'google.com',
        );

  final String idToken;
  final String accessToken;

  @override
  Map<String, Object?> toJson() {
    return {
      'idToken': idToken,
      'accessToken': accessToken,
    };
  }
}

final class AppleSocialLogin extends SocialLogin {
  const AppleSocialLogin({
    required this.identityToken,
    required this.authorizationCode,
    required this.userIdentifier,
  }) : super(providerId: 'apple.com');
  final String identityToken;
  final String authorizationCode;
  final String userIdentifier;

  @override
  Map<String, Object?> toJson() {
    return {
      'identityToken': identityToken,
      'authorizationCode': authorizationCode,
      'userIdentifier': userIdentifier,
    };
  }
}
