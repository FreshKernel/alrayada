// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_product_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductCategoryImpl _$$ProductCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$ProductCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      shortDescription: json['shortDescription'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      parent: json['parent'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => ProductCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ProductCategoryImplToJson(
        _$ProductCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'imageUrls': instance.imageUrls,
      'parent': instance.parent,
      'createdAt': instance.createdAt.toIso8601String(),
      'children': instance.children,
    };

_$ProducrtCategoryRequestImpl _$$ProducrtCategoryRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ProducrtCategoryRequestImpl(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      parent: json['parent'] as String?,
    );

Map<String, dynamic> _$$ProducrtCategoryRequestImplToJson(
        _$ProducrtCategoryRequestImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'shortDescription': instance.shortDescription,
      'parent': instance.parent,
    };
