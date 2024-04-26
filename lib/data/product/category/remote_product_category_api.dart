import 'dart:convert';

import 'package:cross_file/cross_file.dart' show XFile;
import 'package:dio/dio.dart';

import '../../../services/dio_service.dart';
import '../../../utils/constants/routes_constants.dart';
import '../../../utils/extensions/dio_response_ext.dart';
import '../../../utils/extensions/xfile_ext.dart';
import '../../../utils/server.dart';
import 'product_category.dart';
import 'product_category_api.dart';
import 'product_category_exceptions.dart';

class RemoteProductCategoryApi extends ProductCategoryApi {
  final _dio = DioService.instance.dio;

  @override
  Future<ProductCategory> createCategory({
    required String name,
    required String description,
    required String? parentId,
    required XFile imageFile,
  }) async {
    try {
      final response = await _dio.post<Map<String, Object?>>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.productsRoutes.categoryRoutes.createCategory,
        ),
        options: Options(contentType: Headers.multipartFormDataContentType),
        data: FormData.fromMap({
          'body': jsonEncode({
            'name': name,
            'description': description,
            'parentId': parentId,
          }),
          'image': await MultipartFile.fromFile(
            imageFile.path,
            contentType: imageFile.mediaType,
          ),
        }),
      );
      return ProductCategory.fromJson(response.dataOrThrow);
    } on DioException catch (e) {
      throw UnknownProductCategoryException(message: e.message.toString());
    } catch (e) {
      throw UnknownProductCategoryException(message: e.toString());
    }
  }

  @override
  Future<void> deleteCategoryById({required String id}) async {
    try {
      await _dio.delete(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.productsRoutes.categoryRoutes
              .deleteCategoryById(id: id),
        ),
      );
    } on DioException catch (e) {
      throw UnknownProductCategoryException(message: e.message.toString());
    } catch (e) {
      throw UnknownProductCategoryException(message: e.toString());
    }
  }

  @override
  Future<ProductCategory> getCategoryById({required String id}) async {
    try {
      final response = await _dio.get<Map<String, Object?>>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.productsRoutes.categoryRoutes.getCategoryById(id: id),
        ),
      );
      return ProductCategory.fromJson(response.dataOrThrow);
    } on DioException catch (e) {
      throw UnknownProductCategoryException(message: e.message.toString());
    } catch (e) {
      throw UnknownProductCategoryException(message: e.toString());
    }
  }

  @override
  Future<ProductCategory> updateCategoryById({
    required String id,
    required String name,
    required String description,
    required XFile? newImageFile,
  }) async {
    try {
      final response = await _dio.put<Map<String, Object?>>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.productsRoutes.categoryRoutes
              .updateCategoryById(id: id),
        ),
        options: Options(contentType: Headers.multipartFormDataContentType),
        data: FormData.fromMap({
          'body': jsonEncode({
            'name': name,
            'description': description,
          }),
          if (newImageFile != null)
            'image': await MultipartFile.fromFile(
              newImageFile.path,
              contentType: newImageFile.mediaType,
            ),
        }),
      );
      return ProductCategory.fromJson(response.dataOrThrow);
    } on DioException catch (e) {
      throw UnknownProductCategoryException(message: e.message.toString());
    } catch (e) {
      throw UnknownProductCategoryException(message: e.toString());
    }
  }

  @override
  Future<List<ProductCategory>> getChildCategoriesByParentId({
    required String parentId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get<List>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.productsRoutes.categoryRoutes
              .getChildCategoriesByParentId(parentId: parentId),
        ),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return response.dataOrThrow
          .map((e) => ProductCategory.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw UnknownProductCategoryException(message: e.message.toString());
    } catch (e) {
      throw UnknownProductCategoryException(message: e.toString());
    }
  }

  @override
  Future<List<ProductCategory>> getTopLevelCategories({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get<List>(
        ServerConfigurations.getRequestUrl(
          RoutesConstants.productsRoutes.categoryRoutes.getTopLevelCategories,
        ),
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      return response.dataOrThrow
          .map((e) => ProductCategory.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw UnknownProductCategoryException(message: e.message.toString());
    } catch (e) {
      throw UnknownProductCategoryException(message: e.toString());
    }
  }
}
