// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      email: json['email'] as String,
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      pictureUrl: json['pictureUrl'] as String,
      accountActivated: json['accountActivated'] as bool? ?? false,
      emailVerified: json['emailVerified'] as bool? ?? false,
      role:
          $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'data': instance.data,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'pictureUrl': instance.pictureUrl,
      'accountActivated': instance.accountActivated,
      'emailVerified': instance.emailVerified,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.admin: 'Admin',
  UserRole.user: 'User',
};

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      labOwnerPhoneNumber: json['labOwnerPhoneNumber'] as String,
      labPhoneNumber: json['labPhoneNumber'] as String,
      labName: json['labName'] as String,
      labOwnerName: json['labOwnerName'] as String,
      city: $enumDecode(_$IraqGovernorateEnumMap, json['city']),
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
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
      firebase: json['firebase'] as String? ?? '',
      oneSignal: json['oneSignal'] ?? '',
    );

Map<String, dynamic> _$$UserDeviceNotificationsTokenImplToJson(
        _$UserDeviceNotificationsTokenImpl instance) =>
    <String, dynamic>{
      'firebase': instance.firebase,
      'oneSignal': instance.oneSignal,
    };
