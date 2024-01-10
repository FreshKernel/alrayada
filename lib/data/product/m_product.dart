import 'package:freezed_annotation/freezed_annotation.dart';

import '../favorite/m_favorite.dart';

part 'm_product.freezed.dart';
part 'm_product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required String shortDescription,
    required double originalPrice,
    required double discountPercentage,
    required List<String> imageUrls,
    required Set<String> categories,
    required DateTime createdAt,
    @Default(false) bool isFavorite,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  static List<Product> toMappedProducts({
    required List<dynamic> dynamicList,
    required List<Favorite> favorites,
  }) {
    return dynamicList.map((e) {
      var product = Product.fromJson(e);
      product = product.copyWith(
        isFavorite:
            favorites.any((favorite) => favorite.productId == product.id),
      );
      return product;
    }).toList();
  }
}

extension SharedProductExtension on Product {
  double get salePrice =>
      originalPrice - (originalPrice * (discountPercentage / 100));
}

@freezed
class ProductRequest with _$ProductRequest {
  const factory ProductRequest({
    @Default('') String name,
    @Default('') String description,
    @Default('') String shortDescription,
    @Default(0) double originalPrice,
    @Default(0.0) double discountPercentage,
    @Default([]) List<String> categories,
  }) = _ProductRequest;

  factory ProductRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductRequestFromJson(json);
}
