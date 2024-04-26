// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      info: UserInfo.fromJson(json['info'] as Map<String, dynamic>),
      pictureUrl: json['pictureUrl'] as String?,
      isAccountActivated: json['isAccountActivated'] as bool,
      isEmailVerified: json['isEmailVerified'] as bool,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      deviceNotificationsToken: UserDeviceNotificationsToken.fromJson(
          json['deviceNotificationsToken'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'info': instance.info,
      'pictureUrl': instance.pictureUrl,
      'isAccountActivated': instance.isAccountActivated,
      'isEmailVerified': instance.isEmailVerified,
      'role': _$UserRoleEnumMap[instance.role]!,
      'deviceNotificationsToken': instance.deviceNotificationsToken,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'Admin',
  UserRole.user: 'User',
};

_$UserInfoImpl _$$UserInfoImplFromJson(Map<String, dynamic> json) =>
    _$UserInfoImpl(
      labOwnerPhoneNumber: json['labOwnerPhoneNumber'] as String,
      labPhoneNumber: json['labPhoneNumber'] as String,
      labName: json['labName'] as String,
      labOwnerName: json['labOwnerName'] as String,
      city: $enumDecode(_$IraqGovernorateEnumMap, json['city']),
    );

Map<String, dynamic> _$$UserInfoImplToJson(_$UserInfoImpl instance) =>
    <String, dynamic>{
      'labOwnerPhoneNumber': instance.labOwnerPhoneNumber,
      'labPhoneNumber': instance.labPhoneNumber,
      'labName': instance.labName,
      'labOwnerName': instance.labOwnerName,
      'city': _$IraqGovernorateEnumMap[instance.city]!,
    };

const _$IraqGovernorateEnumMap = {
  IraqGovernorate.baghdad: 'Baghdad',
  IraqGovernorate.basra: 'Basra',
  IraqGovernorate.maysan: 'Maysan',
  IraqGovernorate.dhiQar: 'DhiQar',
  IraqGovernorate.diyala: 'Diyala',
  IraqGovernorate.karbala: 'Karbala',
  IraqGovernorate.kirkuk: 'Kirkuk',
  IraqGovernorate.najaf: 'Najaf',
  IraqGovernorate.nineveh: 'Nineveh',
  IraqGovernorate.wasit: 'Wasit',
  IraqGovernorate.anbar: 'Anbar',
  IraqGovernorate.salahAlDin: 'SalahAlDin',
  IraqGovernorate.babil: 'Babil',
  IraqGovernorate.babylon: 'Babylon',
  IraqGovernorate.alMuthanna: 'AlMuthanna',
  IraqGovernorate.alQadisiyyah: 'Al-Qadisiyyah',
  IraqGovernorate.thiQar: 'ThiQar',
};

_$UserDeviceNotificationsTokenImpl _$$UserDeviceNotificationsTokenImplFromJson(
        Map<String, dynamic> json) =>
    _$UserDeviceNotificationsTokenImpl(
      firebase: json['firebase'] as String,
      oneSignal: json['oneSignal'] as String,
    );

Map<String, dynamic> _$$UserDeviceNotificationsTokenImplToJson(
        _$UserDeviceNotificationsTokenImpl instance) =>
    <String, dynamic>{
      'firebase': instance.firebase,
      'oneSignal': instance.oneSignal,
    };
