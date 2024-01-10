// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_cart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cart _$CartFromJson(Map<String, dynamic> json) => Cart(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$CartToJson(Cart instance) => <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };
