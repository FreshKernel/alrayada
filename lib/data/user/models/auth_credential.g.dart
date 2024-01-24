// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserCredentialImpl _$$UserCredentialImplFromJson(Map<String, dynamic> json) =>
    _$UserCredentialImpl(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserCredentialImplToJson(
        _$UserCredentialImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };
