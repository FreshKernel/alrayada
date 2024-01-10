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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get email => throw _privateConstructorUsedError;
  UserData get data => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get pictureUrl => throw _privateConstructorUsedError;
  bool get accountActivated => throw _privateConstructorUsedError;
  bool get emailVerified => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;

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
      {String email,
      UserData data,
      DateTime createdAt,
      String userId,
      String pictureUrl,
      bool accountActivated,
      bool emailVerified,
      UserRole role});

  $UserDataCopyWith<$Res> get data;
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
    Object? email = null,
    Object? data = null,
    Object? createdAt = null,
    Object? userId = null,
    Object? pictureUrl = null,
    Object? accountActivated = null,
    Object? emailVerified = null,
    Object? role = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UserData,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pictureUrl: null == pictureUrl
          ? _value.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String,
      accountActivated: null == accountActivated
          ? _value.accountActivated
          : accountActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res> get data {
    return $UserDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
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
      {String email,
      UserData data,
      DateTime createdAt,
      String userId,
      String pictureUrl,
      bool accountActivated,
      bool emailVerified,
      UserRole role});

  @override
  $UserDataCopyWith<$Res> get data;
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
    Object? email = null,
    Object? data = null,
    Object? createdAt = null,
    Object? userId = null,
    Object? pictureUrl = null,
    Object? accountActivated = null,
    Object? emailVerified = null,
    Object? role = null,
  }) {
    return _then(_$UserImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as UserData,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      pictureUrl: null == pictureUrl
          ? _value.pictureUrl
          : pictureUrl // ignore: cast_nullable_to_non_nullable
              as String,
      accountActivated: null == accountActivated
          ? _value.accountActivated
          : accountActivated // ignore: cast_nullable_to_non_nullable
              as bool,
      emailVerified: null == emailVerified
          ? _value.emailVerified
          : emailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.email,
      required this.data,
      required this.createdAt,
      required this.userId,
      required this.pictureUrl,
      this.accountActivated = false,
      this.emailVerified = false,
      this.role = UserRole.user});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String email;
  @override
  final UserData data;
  @override
  final DateTime createdAt;
  @override
  final String userId;
  @override
  final String pictureUrl;
  @override
  @JsonKey()
  final bool accountActivated;
  @override
  @JsonKey()
  final bool emailVerified;
  @override
  @JsonKey()
  final UserRole role;

  @override
  String toString() {
    return 'User(email: $email, data: $data, createdAt: $createdAt, userId: $userId, pictureUrl: $pictureUrl, accountActivated: $accountActivated, emailVerified: $emailVerified, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pictureUrl, pictureUrl) ||
                other.pictureUrl == pictureUrl) &&
            (identical(other.accountActivated, accountActivated) ||
                other.accountActivated == accountActivated) &&
            (identical(other.emailVerified, emailVerified) ||
                other.emailVerified == emailVerified) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, data, createdAt, userId,
      pictureUrl, accountActivated, emailVerified, role);

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
      {required final String email,
      required final UserData data,
      required final DateTime createdAt,
      required final String userId,
      required final String pictureUrl,
      final bool accountActivated,
      final bool emailVerified,
      final UserRole role}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get email;
  @override
  UserData get data;
  @override
  DateTime get createdAt;
  @override
  String get userId;
  @override
  String get pictureUrl;
  @override
  bool get accountActivated;
  @override
  bool get emailVerified;
  @override
  UserRole get role;
  @override
  @JsonKey(ignore: true)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String get labOwnerPhoneNumber => throw _privateConstructorUsedError;
  String get labPhoneNumber => throw _privateConstructorUsedError;
  String get labName => throw _privateConstructorUsedError;
  String get labOwnerName => throw _privateConstructorUsedError;
  IraqGovernorate get city => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String labOwnerPhoneNumber,
      String labPhoneNumber,
      String labName,
      String labOwnerName,
      IraqGovernorate city});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

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
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
          _$UserDataImpl value, $Res Function(_$UserDataImpl) then) =
      __$$UserDataImplCopyWithImpl<$Res>;
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
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
      _$UserDataImpl _value, $Res Function(_$UserDataImpl) _then)
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
    return _then(_$UserDataImpl(
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
class _$UserDataImpl implements _UserData {
  const _$UserDataImpl(
      {required this.labOwnerPhoneNumber,
      required this.labPhoneNumber,
      required this.labName,
      required this.labOwnerName,
      required this.city});

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

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
    return 'UserData(labOwnerPhoneNumber: $labOwnerPhoneNumber, labPhoneNumber: $labPhoneNumber, labName: $labName, labOwnerName: $labOwnerName, city: $city)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
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
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(
      this,
    );
  }
}

abstract class _UserData implements UserData {
  const factory _UserData(
      {required final String labOwnerPhoneNumber,
      required final String labPhoneNumber,
      required final String labName,
      required final String labOwnerName,
      required final IraqGovernorate city}) = _$UserDataImpl;

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

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
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserDeviceNotificationsToken _$UserDeviceNotificationsTokenFromJson(
    Map<String, dynamic> json) {
  return _UserDeviceNotificationsToken.fromJson(json);
}

/// @nodoc
mixin _$UserDeviceNotificationsToken {
  String get firebase => throw _privateConstructorUsedError;
  dynamic get oneSignal => throw _privateConstructorUsedError;

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
  $Res call({String firebase, dynamic oneSignal});
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
    Object? oneSignal = freezed,
  }) {
    return _then(_value.copyWith(
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as String,
      oneSignal: freezed == oneSignal
          ? _value.oneSignal
          : oneSignal // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
  $Res call({String firebase, dynamic oneSignal});
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
    Object? oneSignal = freezed,
  }) {
    return _then(_$UserDeviceNotificationsTokenImpl(
      firebase: null == firebase
          ? _value.firebase
          : firebase // ignore: cast_nullable_to_non_nullable
              as String,
      oneSignal: freezed == oneSignal ? _value.oneSignal! : oneSignal,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDeviceNotificationsTokenImpl
    implements _UserDeviceNotificationsToken {
  const _$UserDeviceNotificationsTokenImpl(
      {this.firebase = '', this.oneSignal = ''});

  factory _$UserDeviceNotificationsTokenImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UserDeviceNotificationsTokenImplFromJson(json);

  @override
  @JsonKey()
  final String firebase;
  @override
  @JsonKey()
  final dynamic oneSignal;

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
            const DeepCollectionEquality().equals(other.oneSignal, oneSignal));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, firebase, const DeepCollectionEquality().hash(oneSignal));

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
      {final String firebase,
      final dynamic oneSignal}) = _$UserDeviceNotificationsTokenImpl;

  factory _UserDeviceNotificationsToken.fromJson(Map<String, dynamic> json) =
      _$UserDeviceNotificationsTokenImpl.fromJson;

  @override
  String get firebase;
  @override
  dynamic get oneSignal;
  @override
  @JsonKey(ignore: true)
  _$$UserDeviceNotificationsTokenImplCopyWith<
          _$UserDeviceNotificationsTokenImpl>
      get copyWith => throw _privateConstructorUsedError;
}
