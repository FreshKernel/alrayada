import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_category.freezed.dart';
part 'product_category.g.dart';

@freezed
class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    required String id,
    required String name,
    required String description,
    required List<String> imageUrls,
    required String? parent,
    required List<ProductCategory>? children,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, Object> json) =>
      _$ProductCategoryFromJson(json);
}
