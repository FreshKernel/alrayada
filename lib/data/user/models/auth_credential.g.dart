// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserCredentialImpl _$$UserCredentialImplFromJson(Map<String, dynamic> json) =>
    _$UserCredentialImpl(
      token: json['token'] as String,
      expiresIn: json['expiresIn'] as int,
      expiresAt: json['expiresAt'] as int,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserCredentialImplToJson(
        _$UserCredentialImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expiresIn': instance.expiresIn,
      'expiresAt': instance.expiresAt,
      'user': instance.user,
    };
