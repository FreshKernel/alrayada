import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'product_category.g.dart';

@immutable
@JsonSerializable()
class ProductCategory {
  const ProductCategory({
    required this.id,
    required this.name,
    required this.parentId,
    required this.description,
    required this.imageUrls,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, Object?> json) =>
      _$ProductCategoryFromJson(json);

  Map<String, Object?> toJson() => _$ProductCategoryToJson(this);

  final String id;
  final String name;
  final String? parentId;
  final String description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
}
