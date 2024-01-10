// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'm_monthly_total.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MonthlyTotal _$MonthlyTotalFromJson(Map<String, dynamic> json) {
  return _MonthlyTotal.fromJson(json);
}

/// @nodoc
mixin _$MonthlyTotal {
  int get month => throw _privateConstructorUsedError;
  double get total => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MonthlyTotalCopyWith<MonthlyTotal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MonthlyTotalCopyWith<$Res> {
  factory $MonthlyTotalCopyWith(
          MonthlyTotal value, $Res Function(MonthlyTotal) then) =
      _$MonthlyTotalCopyWithImpl<$Res, MonthlyTotal>;
  @useResult
  $Res call({int month, double total});
}

/// @nodoc
class _$MonthlyTotalCopyWithImpl<$Res, $Val extends MonthlyTotal>
    implements $MonthlyTotalCopyWith<$Res> {
  _$MonthlyTotalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? total = null,
  }) {
    return _then(_value.copyWith(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MonthlyTotalImplCopyWith<$Res>
    implements $MonthlyTotalCopyWith<$Res> {
  factory _$$MonthlyTotalImplCopyWith(
          _$MonthlyTotalImpl value, $Res Function(_$MonthlyTotalImpl) then) =
      __$$MonthlyTotalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int month, double total});
}

/// @nodoc
class __$$MonthlyTotalImplCopyWithImpl<$Res>
    extends _$MonthlyTotalCopyWithImpl<$Res, _$MonthlyTotalImpl>
    implements _$$MonthlyTotalImplCopyWith<$Res> {
  __$$MonthlyTotalImplCopyWithImpl(
      _$MonthlyTotalImpl _value, $Res Function(_$MonthlyTotalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? month = null,
    Object? total = null,
  }) {
    return _then(_$MonthlyTotalImpl(
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MonthlyTotalImpl implements _MonthlyTotal {
  const _$MonthlyTotalImpl({required this.month, required this.total});

  factory _$MonthlyTotalImpl.fromJson(Map<String, dynamic> json) =>
      _$$MonthlyTotalImplFromJson(json);

  @override
  final int month;
  @override
  final double total;

  @override
  String toString() {
    return 'MonthlyTotal(month: $month, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MonthlyTotalImpl &&
            (identical(other.month, month) || other.month == month) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, month, total);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MonthlyTotalImplCopyWith<_$MonthlyTotalImpl> get copyWith =>
      __$$MonthlyTotalImplCopyWithImpl<_$MonthlyTotalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MonthlyTotalImplToJson(
      this,
    );
  }
}

abstract class _MonthlyTotal implements MonthlyTotal {
  const factory _MonthlyTotal(
      {required final int month,
      required final double total}) = _$MonthlyTotalImpl;

  factory _MonthlyTotal.fromJson(Map<String, dynamic> json) =
      _$MonthlyTotalImpl.fromJson;

  @override
  int get month;
  @override
  double get total;
  @override
  @JsonKey(ignore: true)
  _$$MonthlyTotalImplCopyWith<_$MonthlyTotalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
