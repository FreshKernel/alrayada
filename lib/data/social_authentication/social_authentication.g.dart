// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialAuthentication _$SocialAuthenticationFromJson(
        Map<String, dynamic> json) =>
    SocialAuthentication(
      deviceToken: UserDeviceNotificationsToken.fromJson(
          json['deviceToken'] as Map<String, dynamic>),
      provider:
          $enumDecode(_$SocialAuthenticationProviderEnumMap, json['provider']),
      signUpUserData: json['signUpUserData'] == null
          ? null
          : UserData.fromJson(json['signUpUserData'] as Map<String, dynamic>),
    );

const _$SocialAuthenticationProviderEnumMap = {
  SocialAuthenticationProvider.google: 'google',
  SocialAuthenticationProvider.apple: 'apple',
};

GoogleAuthentication _$GoogleAuthenticationFromJson(
        Map<String, dynamic> json) =>
    GoogleAuthentication(
      json['idToken'] as String,
      json['signUpUserData'] == null
          ? null
          : UserData.fromJson(json['signUpUserData'] as Map<String, dynamic>),
      UserDeviceNotificationsToken.fromJson(
          json['deviceToken'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GoogleAuthenticationToJson(
        GoogleAuthentication instance) =>
    <String, dynamic>{
      'signUpUserData': instance.signUpUserData?.toJson(),
      'deviceToken': instance.deviceToken.toJson(),
      'idToken': instance.idToken,
    };

AppleAuthentication _$AppleAuthenticationFromJson(Map<String, dynamic> json) =>
    AppleAuthentication(
      json['identityToken'] as String,
      json['userId'] as String,
      json['signUpUserData'] == null
          ? null
          : UserData.fromJson(json['signUpUserData'] as Map<String, dynamic>),
      UserDeviceNotificationsToken.fromJson(
          json['deviceToken'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AppleAuthenticationToJson(
        AppleAuthentication instance) =>
    <String, dynamic>{
      'signUpUserData': instance.signUpUserData?.toJson(),
      'deviceToken': instance.deviceToken.toJson(),
      'identityToken': instance.identityToken,
      'userId': instance.userId,
    };
