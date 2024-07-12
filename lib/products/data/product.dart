import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'product.g.dart';

@immutable
@JsonSerializable()
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.discountPercentage,
    required this.imageNames,
    required this.categoryIds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, Object?> json) =>
      _$ProductFromJson(json);

  Map<String, Object?> toJson() => _$ProductToJson(this);

  final String id;
  final String name;
  final String description;
  final double originalPrice;
  final double discountPercentage;
  final List<String> imageNames;
  final Set<String> categoryIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get salePrice =>
      originalPrice - (originalPrice * (discountPercentage / 100));
}
