import 'package:flutter/foundation.dart';
import '../server.dart';

@immutable
sealed class RoutesConstants {
  const RoutesConstants();

  static const productsRoutes = ProductsRoutes._();
  static const productsCategoryRoutes = ProductCategoryRoutes._();
  static final authRoutes = AuthRoutes._();
  static const offersRoutes = OffersRoutes._();
  static const ordersRoutes = OrdersRoutes._();

  static const appSupportRoutes = AppSupportRoutes._();
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

class AuthRoutes extends RoutesConstants {
  AuthRoutes._();
  static const root = 'auth/';

  final forgotPassword = '${root}forgotPassword';
  final userData = '${root}userData';
  final updatePassword = '${root}updatePassword';
  final socialLogin = '${root}socialLogin';
  final signIn = '${root}signIn';
  final signUp = '${root}signUp';
  final updateDeviceToken = '${root}updateDeviceToken';
  final user = '${root}user';
  final deleteAccount = '${root}deleteAccount';
  final adminRoutes = const AuthAdminRoutes._();
  final signInWithAppleWebRedirectUrl =
      '${ServerConfigurations.getProductionBaseUrl()}authentication/socialLogin/signInWithApple';
}

class AuthAdminRoutes extends RoutesConstants {
  const AuthAdminRoutes._();
  static const root = '${AuthRoutes.root}admin/';
  final getUsers = root;
  final activateUserAccount = '${root}activateAccount';
  final deactivateUserAccount = '${root}deactivateAccount';
  final deleteUser = '${root}deleteUser';
  final sendNotificationToUser = '${root}sendNotification';
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

class AppSupportRoutes extends RoutesConstants {
  const AppSupportRoutes._();
  static const root = 'support/';
  final userChat = root;
  final adminRoutes = const AppSupportAdminRoutes._();
}

class AppSupportAdminRoutes extends RoutesConstants {
  const AppSupportAdminRoutes._();
  static const root = '${AppSupportRoutes.root}admin/';

  /// userRoomId by default is the uuid of the user
  String chatWithUser(String userRoomId) {
    return '${root}chat/$userRoomId';
  }

  final getRooms = '${root}rooms';
  String deleteRoom(String chatRoomId) {
    return '${root}rooms/$chatRoomId';
  }
}
