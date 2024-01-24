import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double originalPrice,
    required double discountPercentage,
    required List<String> imageUrls,
    required List<String> categories,
    required bool isFavorite,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, Object> json) => _$ProductFromJson(json);
}

extension ProductExt on Product {
  double get salePrice =>
      originalPrice - (originalPrice * (discountPercentage / 100));
}

@freezed
class ProductFavorite with _$ProductFavorite {
  const factory ProductFavorite({
    required String productId,
    required DateTime createdAt,
  }) = _ProductFavorite;

  factory ProductFavorite.fromJson(Map<String, Object> json) =>
      _$ProductFavoriteFromJson(json);
}
