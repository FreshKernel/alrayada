// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_credential.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserCredential _$UserCredentialFromJson(Map<String, dynamic> json) {
  return _UserCredential.fromJson(json);
}

/// @nodoc
mixin _$UserCredential {
  String get token => throw _privateConstructorUsedError;
  int get expiresIn => throw _privateConstructorUsedError;
  int get expiresAt => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCredentialCopyWith<UserCredential> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCredentialCopyWith<$Res> {
  factory $UserCredentialCopyWith(
          UserCredential value, $Res Function(UserCredential) then) =
      _$UserCredentialCopyWithImpl<$Res, UserCredential>;
  @useResult
  $Res call({String token, int expiresIn, int expiresAt, User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$UserCredentialCopyWithImpl<$Res, $Val extends UserCredential>
    implements $UserCredentialCopyWith<$Res> {
  _$UserCredentialCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expiresIn = null,
    Object? expiresAt = null,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserCredentialImplCopyWith<$Res>
    implements $UserCredentialCopyWith<$Res> {
  factory _$$UserCredentialImplCopyWith(_$UserCredentialImpl value,
          $Res Function(_$UserCredentialImpl) then) =
      __$$UserCredentialImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String token, int expiresIn, int expiresAt, User user});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$UserCredentialImplCopyWithImpl<$Res>
    extends _$UserCredentialCopyWithImpl<$Res, _$UserCredentialImpl>
    implements _$$UserCredentialImplCopyWith<$Res> {
  __$$UserCredentialImplCopyWithImpl(
      _$UserCredentialImpl _value, $Res Function(_$UserCredentialImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? expiresIn = null,
    Object? expiresAt = null,
    Object? user = null,
  }) {
    return _then(_$UserCredentialImpl(
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      expiresIn: null == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as int,
      expiresAt: null == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as int,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserCredentialImpl implements _UserCredential {
  const _$UserCredentialImpl(
      {required this.token,
      required this.expiresIn,
      required this.expiresAt,
      required this.user});

  factory _$UserCredentialImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserCredentialImplFromJson(json);

  @override
  final String token;
  @override
  final int expiresIn;
  @override
  final int expiresAt;
  @override
  final User user;

  @override
  String toString() {
    return 'UserCredential(token: $token, expiresIn: $expiresIn, expiresAt: $expiresAt, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserCredentialImpl &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, token, expiresIn, expiresAt, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserCredentialImplCopyWith<_$UserCredentialImpl> get copyWith =>
      __$$UserCredentialImplCopyWithImpl<_$UserCredentialImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserCredentialImplToJson(
      this,
    );
  }
}

abstract class _UserCredential implements UserCredential {
  const factory _UserCredential(
      {required final String token,
      required final int expiresIn,
      required final int expiresAt,
      required final User user}) = _$UserCredentialImpl;

  factory _UserCredential.fromJson(Map<String, dynamic> json) =
      _$UserCredentialImpl.fromJson;

  @override
  String get token;
  @override
  int get expiresIn;
  @override
  int get expiresAt;
  @override
  User get user;
  @override
  @JsonKey(ignore: true)
  _$$UserCredentialImplCopyWith<_$UserCredentialImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
