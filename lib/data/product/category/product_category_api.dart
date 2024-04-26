import 'package:cross_file/cross_file.dart' show XFile;

import 'product_category.dart';

abstract class ProductCategoryApi {
  Future<ProductCategory> createCategory({
    required String name,
    required String description,
    required String? parentId,
    required XFile imageFile,
  });
  Future<ProductCategory> updateCategoryById({
    required String id,
    required String name,
    required String description,
    required XFile? newImageFile,
  });
  Future<void> deleteCategoryById({
    required String id,
  });
  Future<List<ProductCategory>> getTopLevelCategories({
    required int page,
    required int limit,
  });
  Future<List<ProductCategory>> getChildCategoriesByParentId({
    required String parentId,
    required int page,
    required int limit,
  });
  Future<ProductCategory> getCategoryById({
    required String id,
  });
}
