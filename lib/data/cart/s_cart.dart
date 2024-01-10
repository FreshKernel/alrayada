// import 'package:sqflite/sqflite.dart';

// import '../../services/native/database/s_sqlite.dart';
// import 'm_cart.dart';

// class CartService {
//   CartService._privateConstructor();
//   static const tableName = 'cart';

//   static final _sqliteService = SqliteService.instance;

//   static Future<bool> isInCart(String productId) async {
//     final db = await _sqliteService.database;
//     final result = await db
//         .query(tableName, where: 'productId = ?', whereArgs: [productId]);
//     await _sqliteService.closeDatabase();
//     return result.isNotEmpty;
//   }

//   static Future<List<Cart>> getItems() async {
//     final db = await _sqliteService.database;
//     final items = await db.query(tableName, orderBy: 'createdAt DESC');
//     await _sqliteService.closeDatabase();
//     if (items.isEmpty) {
//       return [];
//     }
//     final cartItems = items.map(Cart.fromMap).toList();
//     return cartItems;
//   }

//   static Future<int> getItemsCount() async {
//     // await Future.delayed(const Duration(seconds: 3));
//     final db = await _sqliteService.database;
//     final result = await db.rawQuery('SELECT COUNT(*) FROM $tableName');
//     final value = Sqflite.firstIntValue(result) ?? 0;
//     _sqliteService.closeDatabase();
//     return value;
//   }

//   static Future<Cart?> getCartItem(String productId) async {
//     final db = await _sqliteService.database;
//     final result = await db.query(
//       tableName,
//       orderBy: 'createdAt DESC',
//       where: 'productId = ?',
//       whereArgs: [productId],
//     );
//     _sqliteService.closeDatabase();
//     if (result.isEmpty) {
//       return null;
//     }
//     final item = Cart.fromMap(result[0]);
//     return item;
//   }

//   static Future<int> addToCart(Cart cart) async {
//     final db = await _sqliteService.database;
//     final result = await db.insert(tableName, cart.toMap());
//     await _sqliteService.closeDatabase();
//     return result;
//   }

//   static Future<int> updateCartItem(Cart cart) async {
//     final db = await _sqliteService.database;
//     final result = await db.update(tableName, cart.toMap());
//     await _sqliteService.closeDatabase();
//     return result;
//   }

//   static Future<int> removeFromCart(String productId) async {
//     final db = await _sqliteService.database;
//     final result = await db.delete(
//       tableName,
//       where: 'productId = ?',
//       whereArgs: [productId],
//     );
//     await _sqliteService.closeDatabase();
//     return result;
//   }

//   static Future<int> clearCart() async {
//     final db = await _sqliteService.database;
//     final result = await db.delete(tableName);
//     await _sqliteService.closeDatabase();
//     return result;
//   }
// }
