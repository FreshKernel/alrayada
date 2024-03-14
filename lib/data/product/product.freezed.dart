// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  double get originalPrice => throw _privateConstructorUsedError;
  double get discountPercentage => throw _privateConstructorUsedError;
  List<String> get imageUrls => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  bool get isFavorite => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double originalPrice,
      double discountPercentage,
      List<String> imageUrls,
      List<String> categories,
      bool isFavorite,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? originalPrice = null,
    Object? discountPercentage = null,
    Object? imageUrls = null,
    Object? categories = null,
    Object? isFavorite = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
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
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
          _$ProductImpl value, $Res Function(_$ProductImpl) then) =
      __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      double originalPrice,
      double discountPercentage,
      List<String> imageUrls,
      List<String> categories,
      bool isFavorite,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
      _$ProductImpl _value, $Res Function(_$ProductImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? originalPrice = null,
    Object? discountPercentage = null,
    Object? imageUrls = null,
    Object? categories = null,
    Object? isFavorite = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProductImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      originalPrice: null == originalPrice
          ? _value.originalPrice
          : originalPrice // ignore: cast_nullable_to_non_nullable
              as double,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isFavorite: null == isFavorite
          ? _value.isFavorite
          : isFavorite // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$ProductImpl with DiagnosticableTreeMixin implements _Product {
  const _$ProductImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.originalPrice,
      required this.discountPercentage,
      required final List<String> imageUrls,
      required final List<String> categories,
      required this.isFavorite,
      required this.createdAt,
      required this.updatedAt})
      : _imageUrls = imageUrls,
        _categories = categories;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final double originalPrice;
  @override
  final double discountPercentage;
  final List<String> _imageUrls;
  @override
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  final List<String> _categories;
  @override
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final bool isFavorite;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Product(id: $id, name: $name, description: $description, originalPrice: $originalPrice, discountPercentage: $discountPercentage, imageUrls: $imageUrls, categories: $categories, isFavorite: $isFavorite, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Product'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('originalPrice', originalPrice))
      ..add(DiagnosticsProperty('discountPercentage', discountPercentage))
      ..add(DiagnosticsProperty('imageUrls', imageUrls))
      ..add(DiagnosticsProperty('categories', categories))
      ..add(DiagnosticsProperty('isFavorite', isFavorite))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.originalPrice, originalPrice) ||
                other.originalPrice == originalPrice) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.isFavorite, isFavorite) ||
                other.isFavorite == isFavorite) &&
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
      name,
      description,
      originalPrice,
      discountPercentage,
      const DeepCollectionEquality().hash(_imageUrls),
      const DeepCollectionEquality().hash(_categories),
      isFavorite,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(
      this,
    );
  }
}

abstract class _Product implements Product {
  const factory _Product(
      {required final String id,
      required final String name,
      required final String description,
      required final double originalPrice,
      required final double discountPercentage,
      required final List<String> imageUrls,
      required final List<String> categories,
      required final bool isFavorite,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  double get originalPrice;
  @override
  double get discountPercentage;
  @override
  List<String> get imageUrls;
  @override
  List<String> get categories;
  @override
  bool get isFavorite;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProductFavorite _$ProductFavoriteFromJson(Map<String, dynamic> json) {
  return _ProductFavorite.fromJson(json);
}

/// @nodoc
mixin _$ProductFavorite {
  String get productId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductFavoriteCopyWith<ProductFavorite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductFavoriteCopyWith<$Res> {
  factory $ProductFavoriteCopyWith(
          ProductFavorite value, $Res Function(ProductFavorite) then) =
      _$ProductFavoriteCopyWithImpl<$Res, ProductFavorite>;
  @useResult
  $Res call({String productId, DateTime createdAt});
}

/// @nodoc
class _$ProductFavoriteCopyWithImpl<$Res, $Val extends ProductFavorite>
    implements $ProductFavoriteCopyWith<$Res> {
  _$ProductFavoriteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductFavoriteImplCopyWith<$Res>
    implements $ProductFavoriteCopyWith<$Res> {
  factory _$$ProductFavoriteImplCopyWith(_$ProductFavoriteImpl value,
          $Res Function(_$ProductFavoriteImpl) then) =
      __$$ProductFavoriteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String productId, DateTime createdAt});
}

/// @nodoc
class __$$ProductFavoriteImplCopyWithImpl<$Res>
    extends _$ProductFavoriteCopyWithImpl<$Res, _$ProductFavoriteImpl>
    implements _$$ProductFavoriteImplCopyWith<$Res> {
  __$$ProductFavoriteImplCopyWithImpl(
      _$ProductFavoriteImpl _value, $Res Function(_$ProductFavoriteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? productId = null,
    Object? createdAt = null,
  }) {
    return _then(_$ProductFavoriteImpl(
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductFavoriteImpl
    with DiagnosticableTreeMixin
    implements _ProductFavorite {
  const _$ProductFavoriteImpl(
      {required this.productId, required this.createdAt});

  factory _$ProductFavoriteImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductFavoriteImplFromJson(json);

  @override
  final String productId;
  @override
  final DateTime createdAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ProductFavorite(productId: $productId, createdAt: $createdAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ProductFavorite'))
      ..add(DiagnosticsProperty('productId', productId))
      ..add(DiagnosticsProperty('createdAt', createdAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductFavoriteImpl &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, productId, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductFavoriteImplCopyWith<_$ProductFavoriteImpl> get copyWith =>
      __$$ProductFavoriteImplCopyWithImpl<_$ProductFavoriteImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductFavoriteImplToJson(
      this,
    );
  }
}

abstract class _ProductFavorite implements ProductFavorite {
  const factory _ProductFavorite(
      {required final String productId,
      required final DateTime createdAt}) = _$ProductFavoriteImpl;

  factory _ProductFavorite.fromJson(Map<String, dynamic> json) =
      _$ProductFavoriteImpl.fromJson;

  @override
  String get productId;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$ProductFavoriteImplCopyWith<_$ProductFavoriteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
