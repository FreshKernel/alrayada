// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  UserInfo get info => throw _privateConstructorUsedError;
  String? get pictureUrl => throw _privateConstructorUsedError;
  bool get isAccountActivated => throw _privateConstructorUsedError;
  bool get isEmailVerified => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  UserDeviceNotificationsToken get deviceNotificationsToken =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {String id,
      String email,
      UserInfo info,
      String? pictureUrl,
      bool isAccountActivated,
      bool isEmailVerified,
      UserRole role,
      UserDeviceNotificationsToken deviceNotificationsToken,
      DateTime createdAt,
      DateTime updatedAt});

  $UserInfoCopyWith<$Res> get info;
  $UserDeviceNotificationsTokenCopyWith<$Res> get deviceNotificationsToken;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? info = null,
    Object? pictureUrl = freezed,
    Object? isAccountActivated = null,
    Object? isEmailVerified = null,
    Object? role = null,
    Object? deviceNotificationsToken = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as UserInfo,
      pictureUrl: freezed == pictureUrl
          ? _value.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAccountActivated: null == isAccountActivated
          ? _value.isAccountActivated
          : isAccountActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      deviceNotificationsToken: null == deviceNotificationsToken
          ? _value.deviceNotificationsToken
          : deviceNotificationsToken // ignore: cast_nullable_to_non_nullable
              as UserDeviceNotificationsToken,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserInfoCopyWith<$Res> get info {
    return $UserInfoCopyWith<$Res>(_value.info, (value) {
      return _then(_value.copyWith(info: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDeviceNotificationsTokenCopyWith<$Res> get deviceNotificationsToken {
    return $UserDeviceNotificationsTokenCopyWith<$Res>(
        _value.deviceNotificationsToken, (value) {
      return _then(_value.copyWith(deviceNotificationsToken: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String email,
      UserInfo info,
      String? pictureUrl,
      bool isAccountActivated,
      bool isEmailVerified,
      UserRole role,
      UserDeviceNotificationsToken deviceNotificationsToken,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $UserInfoCopyWith<$Res> get info;
  @override
  $UserDeviceNotificationsTokenCopyWith<$Res> get deviceNotificationsToken;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? info = null,
    Object? pictureUrl = freezed,
    Object? isAccountActivated = null,
    Object? isEmailVerified = null,
    Object? role = null,
    Object? deviceNotificationsToken = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      info: null == info
          ? _value.info
          : info // ignore: cast_nullable_to_non_nullable
              as UserInfo,
      pictureUrl: freezed == pictureUrl
          ? _value.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      isAccountActivated: null == isAccountActivated
          ? _value.isAccountActivated
          : isAccountActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      deviceNotificationsToken: null == deviceNotificationsToken
          ? _value.deviceNotificationsToken
          : deviceNotificationsToken // ignore: cast_nullable_to_non_nullable
              as UserDeviceNotificationsToken,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.id,
      required this.email,
      required this.info,
      required this.pictureUrl,
      required this.isAccountActivated,
      required this.isEmailVerified,
      required this.role,
      required this.deviceNotificationsToken,
      required this.createdAt,
      required this.updatedAt});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  final UserInfo info;
  @override
  final String? pictureUrl;
  @override
  final bool isAccountActivated;
  @override
  final bool isEmailVerified;
  @override
  final UserRole role;
  @override
  final UserDeviceNotificationsToken deviceNotificationsToken;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'User(id: $id, email: $email, info: $info, pictureUrl: $pictureUrl, isAccountActivated: $isAccountActivated, isEmailVerified: $isEmailVerified, role: $role, deviceNotificationsToken: $deviceNotificationsToken, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.info, info) || other.info == info) &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl) &&
            (identical(other.isAccountActivated, isAccountActivated) ||
                other.isAccountActivated == isAccountActivated) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(
                    other.deviceNotificationsToken, deviceNotificationsToken) ||
                other.deviceNotificationsToken == deviceNotificationsToken) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      info,
      pictureUrl,
      isAccountActivated,
      isEmailVerified,
      role,
      deviceNotificationsToken,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String id,
      required final String email,
      required final UserInfo info,
      required final String? pictureUrl,
      required final bool isAccountActivated,
      required final bool isEmailVerified,
      required final UserRole role,
      required final UserDeviceNotificationsToken deviceNotificationsToken,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get email;
  @override
  UserInfo get info;
  @override
  String? get pictureUrl;
  @override
  bool get isAccountActivated;
  @override
  bool get isEmailVerified;
  @override
  UserRole get role;
  @override
  UserDeviceNotificationsToken get deviceNotificationsToken;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return _UserInfo.fromJson(json);
}

/// @nodoc
mixin _$UserInfo {
  String get labOwnerPhoneNumber => throw _privateConstructorUsedError;
  String get labPhoneNumber => throw _privateConstructorUsedError;
  String get labName => throw _privateConstructorUsedError;
  String get labOwnerName => throw _privateConstructorUsedError;
  IraqGovernorate get city => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
  @useResult
  $Res call(
      {String labOwnerPhoneNumber,
      String labPhoneNumber,
      String labName,
      String labOwnerName,
      IraqGovernorate city});
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? labOwnerPhoneNumber = null,
    Object? labPhoneNumber = null,
    Object? labName = null,
    Object? labOwnerName = null,
    Object? city = null,
  }) {
    return _then(_value.copyWith(
      labOwnerPhoneNumber: null == labOwnerPhoneNumber
          ? _value.labOwnerPhoneNumber
          : labOwnerPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      labPhoneNumber: null == labPhoneNumber
          ? _value.labPhoneNumber
          : labPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      labName: null == labName
          ? _value.labName
          : labName // ignore: cast_nullable_to_non_nullable
              as String,
      labOwnerName: null == labOwnerName
          ? _value.labOwnerName
          : labOwnerName // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as IraqGovernorate,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserInfoImplCopyWith<$Res>
    implements $UserInfoCopyWith<$Res> {
  factory _$$UserInfoImplCopyWith(
          _$UserInfoImpl value, $Res Function(_$UserInfoImpl) then) =
      __$$UserInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String labOwnerPhoneNumber,
      String labPhoneNumber,
      String labName,
      String labOwnerName,
      IraqGovernorate city});
}

/// @nodoc
class __$$UserInfoImplCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$UserInfoImpl>
    implements _$$UserInfoImplCopyWith<$Res> {
  __$$UserInfoImplCopyWithImpl(
      _$UserInfoImpl _value, $Res Function(_$UserInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? labOwnerPhoneNumber = null,
    Object? labPhoneNumber = null,
    Object? labName = null,
    Object? labOwnerName = null,
    Object? city = null,
  }) {
    return _then(_$UserInfoImpl(
      labOwnerPhoneNumber: null == labOwnerPhoneNumber
          ? _value.labOwnerPhoneNumber
          : labOwnerPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      labPhoneNumber: null == labPhoneNumber
          ? _value.labPhoneNumber
          : labPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      labName: null == labName
          ? _value.labName
          : labName // ignore: cast_nullable_to_non_nullable
              as String,
      labOwnerName: null == labOwnerName
          ? _value.labOwnerName
          : labOwnerName // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as IraqGovernorate,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserInfoImpl implements _UserInfo {
  const _$UserInfoImpl(
      {required this.labOwnerPhoneNumber,
      required this.labPhoneNumber,
      required this.labName,
      required this.labOwnerName,
      required this.city});

  factory _$UserInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserInfoImplFromJson(json);

  @override
  final String labOwnerPhoneNumber;
  @override
  final String labPhoneNumber;
  @override
  final String labName;
  @override
  final String labOwnerName;
  @override
  final IraqGovernorate city;

  @override
  String toString() {
    return 'UserInfo(labOwnerPhoneNumber: $labOwnerPhoneNumber, labPhoneNumber: $labPhoneNumber, labName: $labName, labOwnerName: $labOwnerName, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserInfoImpl &&
            (identical(other.labOwnerPhoneNumber, labOwnerPhoneNumber) ||
                other.labOwnerPhoneNumber == labOwnerPhoneNumber) &&
            (identical(other.labPhoneNumber, labPhoneNumber) ||
                other.labPhoneNumber == labPhoneNumber) &&
            (identical(other.labName, labName) || other.labName == labName) &&
            (identical(other.labOwnerName, labOwnerName) ||
                other.labOwnerName == labOwnerName) &&
            (identical(other.city, city) || other.city == city));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, labOwnerPhoneNumber,
      labPhoneNumber, labName, labOwnerName, city);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      __$$UserInfoImplCopyWithImpl<_$UserInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserInfoImplToJson(
      this,
    );
  }
}

abstract class _UserInfo implements UserInfo {
  const factory _UserInfo(
      {required final String labOwnerPhoneNumber,
      required final String labPhoneNumber,
      required final String labName,
      required final String labOwnerName,
      required final IraqGovernorate city}) = _$UserInfoImpl;

  factory _UserInfo.fromJson(Map<String, dynamic> json) =
      _$UserInfoImpl.fromJson;

  @override
  String get labOwnerPhoneNumber;
  @override
  String get labPhoneNumber;
  @override
  String get labName;
  @override
  String get labOwnerName;
  @override
  IraqGovernorate get city;
  @override
  @JsonKey(ignore: true)
  _$$UserInfoImplCopyWith<_$UserInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDeviceNotificationsToken _$UserDeviceNotificationsTokenFromJson(
    Map<String, dynamic> json) {
  return _UserDeviceNotificationsToken.fromJson(json);
}

/// @nodoc
mixin _$UserDeviceNotificationsToken {
  String get firebase => throw _privateConstructorUsedError;
  String get oneSignal => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDeviceNotificationsTokenCopyWith<UserDeviceNotificationsToken>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDeviceNotificationsTokenCopyWith<$Res> {
  factory $UserDeviceNotificationsTokenCopyWith(
          UserDeviceNotificationsToken value,
          $Res Function(UserDeviceNotificationsToken) then) =
      _$UserDeviceNotificationsTokenCopyWithImpl<$Res,
          UserDeviceNotificationsToken>;
  @useResult
  $Res call({String firebase, String oneSignal});
}

/// @nodoc
class _$UserDeviceNotificationsTokenCopyWithImpl<$Res,
        $Val extends UserDeviceNotificationsToken>
    implements $UserDeviceNotificationsTokenCopyWith<$Res> {
  _$UserDeviceNotificationsTokenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebase = null,
    Object? oneSignal = null,
  }) {
    return _then(_value.copyWith(
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as String,
      oneSignal: null == oneSignal
          ? _value.oneSignal
          : oneSignal // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDeviceNotificationsTokenImplCopyWith<$Res>
    implements $UserDeviceNotificationsTokenCopyWith<$Res> {
  factory _$$UserDeviceNotificationsTokenImplCopyWith(
          _$UserDeviceNotificationsTokenImpl value,
          $Res Function(_$UserDeviceNotificationsTokenImpl) then) =
      __$$UserDeviceNotificationsTokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String firebase, String oneSignal});
}

/// @nodoc
class __$$UserDeviceNotificationsTokenImplCopyWithImpl<$Res>
    extends _$UserDeviceNotificationsTokenCopyWithImpl<$Res,
        _$UserDeviceNotificationsTokenImpl>
    implements _$$UserDeviceNotificationsTokenImplCopyWith<$Res> {
  __$$UserDeviceNotificationsTokenImplCopyWithImpl(
      _$UserDeviceNotificationsTokenImpl _value,
      $Res Function(_$UserDeviceNotificationsTokenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firebase = null,
    Object? oneSignal = null,
  }) {
    return _then(_$UserDeviceNotificationsTokenImpl(
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as String,
      oneSignal: null == oneSignal
          ? _value.oneSignal
          : oneSignal // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDeviceNotificationsTokenImpl
    implements _UserDeviceNotificationsToken {
  const _$UserDeviceNotificationsTokenImpl(
      {required this.firebase, required this.oneSignal});

  factory _$UserDeviceNotificationsTokenImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UserDeviceNotificationsTokenImplFromJson(json);

  @override
  final String firebase;
  @override
  final String oneSignal;

  @override
  String toString() {
    return 'UserDeviceNotificationsToken(firebase: $firebase, oneSignal: $oneSignal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDeviceNotificationsTokenImpl &&
            (identical(other.firebase, firebase) ||
                other.firebase == firebase) &&
            (identical(other.oneSignal, oneSignal) ||
                other.oneSignal == oneSignal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firebase, oneSignal);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDeviceNotificationsTokenImplCopyWith<
          _$UserDeviceNotificationsTokenImpl>
      get copyWith => __$$UserDeviceNotificationsTokenImplCopyWithImpl<
          _$UserDeviceNotificationsTokenImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDeviceNotificationsTokenImplToJson(
      this,
    );
  }
}

abstract class _UserDeviceNotificationsToken
    implements UserDeviceNotificationsToken {
  const factory _UserDeviceNotificationsToken(
      {required final String firebase,
      required final String oneSignal}) = _$UserDeviceNotificationsTokenImpl;

  factory _UserDeviceNotificationsToken.fromJson(Map<String, dynamic> json) =
      _$UserDeviceNotificationsTokenImpl.fromJson;

  @override
  String get firebase;
  @override
  String get oneSignal;
  @override
  @JsonKey(ignore: true)
  _$$UserDeviceNotificationsTokenImplCopyWith<
          _$UserDeviceNotificationsTokenImpl>
      get copyWith => throw _privateConstructorUsedError;
}
