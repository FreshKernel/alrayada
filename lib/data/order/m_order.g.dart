// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'm_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      notes: json['notes'] as String,
    );

OrderRequest _$OrderRequestFromJson(Map<String, dynamic> json) => OrderRequest(
      items: (json['items'] as List<dynamic>)
          .map((e) => Cart.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String,
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
    );

Map<String, dynamic> _$OrderRequestToJson(OrderRequest instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'notes': instance.notes,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'Cash',
  PaymentMethod.zainCash: 'ZainCash',
  PaymentMethod.creditCard: 'CreditCard',
};

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
      id: json['id'] as String,
      orderNumber: json['orderNumber'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String,
      adminNotes: json['adminNotes'] as String,
      totalOriginalPrice: (json['totalOriginalPrice'] as num).toDouble(),
      totalSalePrice: (json['totalSalePrice'] as num).toDouble(),
      paymentMethod: $enumDecode(_$PaymentMethodEnumMap, json['paymentMethod']),
      paymentMethodData:
          Map<String, String>.from(json['paymentMethodData'] as Map),
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      isPaid: json['isPaid'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      deliveryDate: json['deliveryDate'] == null
          ? null
          : DateTime.parse(json['deliveryDate'] as String),
      userData: json['userData'] == null
          ? null
          : UserData.fromJson(json['userData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'userId': instance.userId,
      'items': instance.items,
      'notes': instance.notes,
      'adminNotes': instance.adminNotes,
      'totalOriginalPrice': instance.totalOriginalPrice,
      'totalSalePrice': instance.totalSalePrice,
      'paymentMethod': _$PaymentMethodEnumMap[instance.paymentMethod]!,
      'paymentMethodData': instance.paymentMethodData,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'isPaid': instance.isPaid,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deliveryDate': instance.deliveryDate?.toIso8601String(),
      'userData': instance.userData,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'Pending',
  OrderStatus.approved: 'Approved',
  OrderStatus.rejected: 'Rejected',
  OrderStatus.cancelled: 'Cancelled',
};

Map<String, dynamic> _$$OrderItemImplToJson(_$OrderItemImpl instance) =>
    <String, dynamic>{
      'product': instance.product,
      'quantity': instance.quantity,
      'notes': instance.notes,
    };
