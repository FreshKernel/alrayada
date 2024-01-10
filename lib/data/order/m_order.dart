import 'package:freezed_annotation/freezed_annotation.dart';

import '../cart/m_cart.dart';

import '../product/m_product.dart';
import '../user/models/user.dart';

part 'm_order.freezed.dart';
part 'm_order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String orderNumber,
    required String userId,
    required List<OrderItem> items,
    required String notes,
    required String adminNotes,
    required double totalOriginalPrice,
    required double totalSalePrice,
    required PaymentMethod paymentMethod,
    required Map<String, String> paymentMethodData,
    required OrderStatus status,
    required bool isPaid,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deliveryDate,
    UserData? userData, // for admin
  }) = _Order;
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

@Freezed(toJson: true, fromJson: false)
@JsonSerializable(explicitToJson: true, createToJson: false)
class OrderItem with _$OrderItem {
  const factory OrderItem({
    required Product product,
    required int quantity,
    required String notes,
  }) = _OrderItem;
  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

enum OrderStatus {
  @JsonValue('Pending')
  pending,
  @JsonValue('Approved')
  approved,
  @JsonValue('Rejected')
  rejected,
  @JsonValue('Cancelled')
  cancelled
}

enum PaymentMethod {
  @JsonValue('Cash')
  cash,
  @JsonValue('ZainCash')
  zainCash,
  @JsonValue('CreditCard')
  creditCard
}

@Freezed(fromJson: false, toJson: false)
@JsonSerializable(explicitToJson: true, createToJson: true)
class OrderRequest with _$OrderRequest {
  const factory OrderRequest({
    required List<Cart> items,
    required String notes,
    required PaymentMethod paymentMethod,
  }) = _OrderRequest;
  factory OrderRequest.fromJson(Map<String, dynamic> json) =>
      _$OrderRequestFromJson(json);
}

extension OrderRequestShared on OrderRequest {
  Map<String, dynamic> toJson() => _$OrderRequestToJson(this);
}
