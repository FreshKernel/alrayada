// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      imageNames: (json['imageNames'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      categoryIds: (json['categoryIds'] as List<dynamic>)
          .map((e) => e as String)
          .toSet(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'originalPrice': instance.originalPrice,
      'discountPercentage': instance.discountPercentage,
      'imageNames': instance.imageNames,
      'categoryIds': instance.categoryIds.toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
