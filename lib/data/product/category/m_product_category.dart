import 'package:freezed_annotation/freezed_annotation.dart';

part 'm_product_category.freezed.dart';
part 'm_product_category.g.dart';

@freezed
class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    required String id,
    required String name,
    required String description,
    required String shortDescription,
    required List<String> imageUrls,
    required String? parent,
    required DateTime createdAt,
    required List<ProductCategory>? children,
  }) = _ProductCategory;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);
}

@freezed
class ProductCategoryRequest with _$ProductCategoryRequest {
  const factory ProductCategoryRequest({
    @Default('') String name,
    @Default('') String description,
    @Default('') String shortDescription,
    String? parent,
  }) = _ProducrtCategoryRequest;

  factory ProductCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryRequestFromJson(json);
}
