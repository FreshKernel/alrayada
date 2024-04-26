import 'package:meta/meta.dart';

@immutable
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

  factory Product.fromJson(Map<String, Object?> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        originalPrice: json['originalPrice'] as double,
        discountPercentage: json['discountPercentage'] as double,
        imageNames: List<String>.from(json['imageNames'] as List<String>),
        categoryIds: Set<String>.from(json['categoryIds'] as Set<String>),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'originalPrice': originalPrice,
        'discountPercentage': discountPercentage,
        'imageNames': imageNames,
        'categoryIds': categoryIds.toList(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

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
