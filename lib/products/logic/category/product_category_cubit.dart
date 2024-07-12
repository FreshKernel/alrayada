import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/category/product_category.dart';
import '../../data/category/product_category_api.dart';
import '../../data/category/product_category_exceptions.dart';

part 'product_category_state.dart';

class ProductCategoryCubit extends Cubit<ProductCategoryState> {
  ProductCategoryCubit({
    required this.productCategoryApi,
  }) : super(const ProductCategoryInitial()) {
    loadTopLevelCategories();
  }

  final ProductCategoryApi productCategoryApi;

  static const _limit = 10;

  Future<void> loadTopLevelCategories() async {
    try {
      emit(const ProductCategoryLoadTopLevelInProgress());
      final categories = await productCategoryApi.getCategories(
        page: 1,
        limit: _limit,
      );
      emit(ProductCategoryLoadTopLevelSuccess(
        topLevelCategoriesState: ProductCategoryCategoriesState(
          categories: categories,
          hasReachedLastPage: categories.isEmpty,
        ),
      ));
    } on ProductCategoryException catch (e) {
      emit(ProductCategoryLoadTopLevelFailure(e));
    }
  }

  Future<void> loadMoreTopLevelCategories() async {
    if (state.topLevelCategoriesState.hasReachedLastPage) {
      return;
    }
    if (state is ProductCategoryLoadTopLevelMoreInProgress) {
      // In case if the function called more than once
      return;
    }
    emit(ProductCategoryLoadTopLevelMoreInProgress(
      topLevelCategoriesState: state.topLevelCategoriesState.copyWith(
        page: state.topLevelCategoriesState.page + 1,
      ),
    ));
    final moreCategories = await productCategoryApi.getCategories(
      page: state.topLevelCategoriesState.page,
      limit: _limit,
    );
    emit(ProductCategoryLoadTopLevelSuccess(
      topLevelCategoriesState: state.topLevelCategoriesState.copyWith(
        categories: [
          ...state.topLevelCategoriesState.categories,
          ...moreCategories,
        ],
        hasReachedLastPage: moreCategories.isEmpty,
      ),
    ));
  }

  Future<void> createCategory({
    required String? parentId,
    required String name,
    required String description,
    required XFile imageFile,
  }) async {
    try {
      emit(ProductCategoryCreateInProgress(
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
      final category = await productCategoryApi.createCategory(
        name: name,
        description: description,
        parentId: parentId,
        imageFile: imageFile,
      );
      if (parentId == null) {
        // Top level category
        emit(ProductCategoryCreateSuccess(
          childCategoriesStateMap: state.childCategoriesStateMap,
          topLevelCategoriesState: state.topLevelCategoriesState.copyWith(
            categories: [
              category,
              ...state.topLevelCategoriesState.categories,
            ],
          ),
        ));
        return;
      }
      // Sub category
      final childCategoriesState =
          state.getChildCategoriesStateOrThrow(parentId: parentId);
      emit(ProductCategoryCreateSuccess(
        childCategoriesStateMap: {...state.childCategoriesStateMap}
          ..[parentId] = childCategoriesState.copyWith(
            categories: [
              category,
              ...childCategoriesState.categories,
            ],
          ),
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    } on ProductCategoryException catch (e) {
      emit(ProductCategoryCreateFailure(
        e,
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    }
  }

  /// [parentId] If this a sub-category, then pass the parent category id of this child
  Future<void> deleteCategoryById({
    required String id,
    required String? parentId,
  }) async {
    try {
      emit(ProductCategoryActionInProgress(
        categoryId: id,
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
      await productCategoryApi.deleteCategoryById(id: id);
      if (parentId == null) {
        // Top level category
        final categories = [...state.topLevelCategoriesState.categories]
          ..removeWhere(
            (category) => category.id == id,
          );
        emit(ProductCategoryActionSuccess(
          childCategoriesStateMap: state.childCategoriesStateMap,
          topLevelCategoriesState: state.topLevelCategoriesState.copyWith(
            categories: categories,
          ),
        ));
        return;
      }
      // Sub category
      final childCategoriesState =
          state.getChildCategoriesStateOrThrow(parentId: parentId);
      emit(ProductCategoryActionSuccess(
        childCategoriesStateMap: {...state.childCategoriesStateMap}
          ..[parentId] = childCategoriesState.copyWith(categories: [
            ...childCategoriesState.categories
              ..removeWhere((element) => element.id == id)
          ]),
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    } on ProductCategoryException catch (e) {
      emit(ProductCategoryActionFailure(
        e,
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    }
  }

  /// [parentId] If this a sub-category, then pass the parent category id of this child
  Future<void> updateCategoryById({
    required String id,
    required String name,
    required String description,
    required XFile? newImageFile,
    required String? parentId,
  }) async {
    try {
      emit(ProductCategoryActionInProgress(
        categoryId: id,
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
      final newCategory = await productCategoryApi.updateCategoryById(
        id: id,
        name: name,
        description: description,
        newImageFile: newImageFile,
      );
      if (parentId == null) {
        // Top level category
        final categoryIndex =
            state.topLevelCategoriesState.categories.indexWhere(
          (category) => category.id == id,
        );
        final categories = [...state.topLevelCategoriesState.categories]
          ..[categoryIndex] = newCategory;
        emit(ProductCategoryActionSuccess(
          childCategoriesStateMap: state.childCategoriesStateMap,
          topLevelCategoriesState: state.topLevelCategoriesState.copyWith(
            categories: categories,
          ),
        ));
        return;
      }
      // Sub category
      final childCategoriesState =
          state.getChildCategoriesStateOrThrow(parentId: parentId);
      final categoryIndex = childCategoriesState.categories
          .indexWhere((element) => element.id == id);
      emit(ProductCategoryActionSuccess(
        childCategoriesStateMap: {...state.childCategoriesStateMap}
          ..[parentId] = childCategoriesState.copyWith(
            categories: [...childCategoriesState.categories]..[categoryIndex] =
                newCategory,
          ),
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    } on ProductCategoryException catch (e) {
      emit(ProductCategoryActionFailure(
        e,
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    }
  }

  Future<void> loadChildCategories({
    required String parentId,
    bool isSkipIfLoaded = false,
  }) async {
    try {
      if (isSkipIfLoaded) {
        final isLoaded = state.childCategoriesStateMap[parentId] != null;
        if (isLoaded) {
          return;
        }
      }
      emit(ProductCategoryLoadChildInProgress(
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
      final childCategories = await productCategoryApi.getCategories(
        parentId: parentId,
        page: 1,
        limit: _limit,
      );
      emit(ProductCategoryLoadChildSuccess(
        childCategoriesStateMap: {...state.childCategoriesStateMap}
          ..[parentId] = ProductCategoryCategoriesState(
            categories: childCategories,
            hasReachedLastPage: childCategories.isEmpty,
          ),
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    } on ProductCategoryException catch (e) {
      emit(ProductCategoryLoadChildFailure(
        e,
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    }
  }

  Future<void> loadMoreChildCategories({
    required String parentId,
  }) async {
    final childCategoriesState =
        state.getChildCategoriesStateOrThrow(parentId: parentId);
    try {
      if (childCategoriesState.hasReachedLastPage) {
        return;
      }
      if (state is ProductCategoryLoadChildMoreInProgress) {
        // In case if the function called more than once
        return;
      }
      emit(ProductCategoryLoadChildMoreInProgress(
        childCategoriesStateMap: {...state.childCategoriesStateMap}
          ..[parentId] = childCategoriesState.copyWith(
            page: childCategoriesState.page + 1,
          ),
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
      final moreChildCategories = await productCategoryApi.getCategories(
        parentId: parentId,
        page: childCategoriesState.page,
        limit: _limit,
      );
      emit(ProductCategoryLoadChildSuccess(
        childCategoriesStateMap: {...state.childCategoriesStateMap}
          ..[parentId] = childCategoriesState.copyWith(
            categories: [
              ...childCategoriesState.categories,
              ...moreChildCategories
            ],
            hasReachedLastPage: moreChildCategories.isEmpty,
          ),
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    } on ProductCategoryException catch (e) {
      emit(ProductCategoryLoadChildFailure(
        e,
        childCategoriesStateMap: state.childCategoriesStateMap,
        topLevelCategoriesState: state.topLevelCategoriesState,
      ));
    }
  }
}
