import 'package:meta/meta.dart';

@immutable
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
      ProductCategory(
        id: json['id'] as String,
        name: json['name'] as String,
        parentId: json['parentId'] as String?,
        description: json['description'] as String,
        imageUrls: List<String>.from(json['imageUrls'] as List),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'parentId': parentId,
        'description': description,
        'imageUrls': imageUrls,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  final String id;
  final String name;
  final String? parentId;
  final String description;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime updatedAt;
}
