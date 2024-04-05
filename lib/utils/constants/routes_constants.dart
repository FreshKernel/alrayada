import 'package:flutter/foundation.dart';

@immutable
sealed class RoutesConstants {
  const RoutesConstants();

  static const authRoutes = AuthRoutes._();
  static const productsRoutes = ProductsRoutes._();
  static const productsCategoryRoutes = ProductCategoryRoutes._();
  static const offersRoutes = OffersRoutes._();
  static const ordersRoutes = OrdersRoutes._();

  static const liveChatRoutes = LiveChatRoutes._();
}

class AuthRoutes extends RoutesConstants {
  const AuthRoutes._();
  static const root = 'auth';

  final signIn = '$root/signIn';
  final signUp = '$root/signUp';
  final socialLogin = '$root/socialLogin';

  final getUserData = '$root/userData';
  final updateUserInfo = '$root/updateUserInfo';

  final sendEmailVerificationLink = '$root/sendEmailVerificationLink';
  final sendResetPasswordLink = '$root/sendResetPasswordLink';

  final deleteSelfAccount = '$root/deleteSelfAccount';
  final updatePassword = '$root/updatePassword';
  final updateDeviceNotificationsToken = '$root/updateDeviceNotificationsToken';

  final adminRoutes = const AuthAdminRoutes._();
}

class AuthAdminRoutes extends RoutesConstants {
  const AuthAdminRoutes._();
  static const root = '${AuthRoutes.root}/admin';
  final getAllUsers = '$root/users';
  final deleteUser = '$root/deleteUser';
  final setAccountActivated = '$root/setAccountActivated';
  final sendNotificationToUser = '$root/sendNotificationToUser';
}

class ProductsRoutes extends RoutesConstants {
  const ProductsRoutes._();
  static const root = 'products/';

  final getProducts = root;
  final addProduct = root;
  String getProductsByCategory(String id) {
    return '${root}byCategory/$id';
  }

  String deleteProduct(String id) {
    return root + id;
  }

  String updateProduct(String id) {
    return root + id;
  }
}

class ProductCategoryRoutes extends RoutesConstants {
  const ProductCategoryRoutes._();
  static const root = 'products/categories/';
  final getCategories = root;
  final addCategory = root;
  String deleteCategory(String id) {
    return root + id;
  }

  String updateCategory(String id) {
    return root + id;
  }
}

class OffersRoutes extends RoutesConstants {
  const OffersRoutes._();
  static const root = 'offers/';

  final getOffers = root;
  final addOffer = root;
  String deleteOffer(String id) {
    return root + id;
  }
}

class OrdersRoutes extends RoutesConstants {
  const OrdersRoutes._();
  static const root = 'orders/';
  final getOrders = root;
  final checkout = '${root}checkout';
  final getStatistics = '${root}statistics';
  final cancelOrder = '${root}cancelOrder';
  final isOrderPaid = '${root}isOrderPaid';
  final adminRoutes = const OrdersAdminRoutes._();
}

class OrdersAdminRoutes extends RoutesConstants {
  const OrdersAdminRoutes._();
  static const root = '${OrdersRoutes.root}admin';
  final deleteOrder = '$root/deleteOrder';
  final approveOrder = '$root/approveOrder';
  final rejectOrder = '$root/rejectOrder';
}

class LiveChatRoutes extends RoutesConstants {
  const LiveChatRoutes._();
  static const root = 'liveChat';
  final userLiveChat = '$root/';
  final getMessages = '$root/messages';
  final adminRoutes = const AdminLiveChatRoutes._();
}

class AdminLiveChatRoutes extends RoutesConstants {
  const AdminLiveChatRoutes._();
  static const root = '${LiveChatRoutes.root}/admin';

  /// userRoomId by default is the uuid of the user
  String chatWithUser(String userRoomId) {
    return '$root/chat/$userRoomId';
  }

  final getRooms = '${root}rooms';
  String deleteRoom(String chatRoomId) {
    return '$root/rooms/$chatRoomId';
  }
}
