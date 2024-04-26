// import 'package:freezed_annotation/freezed_annotation.dart';

// import '../product/product.dart';

// part 'order.freezed.dart';
// part 'order.g.dart';

// @freezed
// class Order with _$Order {
//   const factory Order({
//     required String id,
//     required String orderNumber,
//     required String userId,
//     required List<OrderItem> items,
//     required String notes,
//     required String adminNotes,
//     required DateTime? deliveryDate,
//     required double totalOriginalPrice,
//     required double totalSalePrice,
//     required PaymentMethod paymentMethod,
//     required Map<String, String> paymentMethodData,
//     required OrderStatus status,
//     required bool isPaid,
//     required DateTime createdAt,
//     required DateTime updatedAt,
//   }) = _Order;

//   factory Order.fromJson(Map<String, Object> json) => _$OrderFromJson(json);
// }

// @freezed
// class OrderItem with _$OrderItem {
//   const factory OrderItem({
//     required Product product,
//     required int quantity,
//     required String notes,
//   }) = _OrderItem;

//   factory OrderItem.fromJson(Map<String, Object> json) =>
//       _$OrderItemFromJson(json);
// }

// enum OrderStatus {
//   @JsonValue('Pending')
//   pending,
//   @JsonValue('Approved')
//   approved,
//   @JsonValue('Rejected')
//   rejected,
//   @JsonValue('Cancelled')
//   cancelled
// }

// enum PaymentMethod {
//   @JsonValue('Cash')
//   cash,
//   @JsonValue('ZainCash')
//   zainCash,
//   @JsonValue('CreditCard')
//   creditCard
// }
