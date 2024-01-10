// import '../../services/native/database/s_sqlite.dart';
// import 'm_favorite.dart';

// class FavoriteService {
//   FavoriteService._privateConstructor();
//   static const tableName = 'favorites';

//   static final _sqliteService = SqliteService.instance;

//   static Future<bool> isFavorite(String productId) async {
//     final db = await _sqliteService.database;
//     final result = await db
//         .query(tableName, where: 'productId = ?', whereArgs: [productId]);
//     await _sqliteService.closeDatabase();
//     return result.isNotEmpty;
//   }

//   static Future<List<Favorite>> getFavorites() async {
//     final db = await _sqliteService.database;
//     final items = await db.query(tableName, orderBy: 'createdAt DESC');
//     await _sqliteService.closeDatabase();
//     if (items.isEmpty) {
//       return [];
//     }
//     final cartItems = items.map(Favorite.fromMap).toList();
//     return cartItems;
//   }

//   static Future<int> addToFavorites(Favorite favorite) async {
//     final db = await _sqliteService.database;
//     final result = await db.insert(tableName, favorite.toMap());
//     await _sqliteService.closeDatabase();
//     return result;
//   }

//   static Future<int> removeFromFavorites(String productId) async {
//     final db = await _sqliteService.database;
//     final result = await db.delete(
//       tableName,
//       where: 'productId = ?',
//       whereArgs: [productId],
//     );
//     await _sqliteService.closeDatabase();
//     return result;
//   }

//   static Future<int> clearAllFavorites() async {
//     final db = await _sqliteService.database;
//     final result = await db.delete(tableName);
//     await _sqliteService.closeDatabase();
//     return result;
//   }
// }
