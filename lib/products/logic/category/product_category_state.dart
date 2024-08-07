part of 'product_category_cubit.dart';

/// This is the categories for the [ProductCategoryState]
@immutable
class ProductCategoryCategoriesState extends Equatable {
  const ProductCategoryCategoriesState({
    this.categories = const [],
    this.page = 1,
    this.hasReachedLastPage = false,
    // TODO: I might add search
  });

  final List<ProductCategory> categories;
  final int page;
  final bool hasReachedLastPage;
  @override
  List<Object?> get props => [categories, page, hasReachedLastPage];

  ProductCategoryCategoriesState copyWith({
    List<ProductCategory>? categories,
    int? page,
    bool? hasReachedLastPage,
  }) {
    return ProductCategoryCategoriesState(
      categories: categories ?? this.categories,
      page: page ?? this.page,
      hasReachedLastPage: hasReachedLastPage ?? this.hasReachedLastPage,
    );
  }
}

@immutable
sealed class ProductCategoryState extends Equatable {
  const ProductCategoryState({
    this.topLevelCategoriesState = const ProductCategoryCategoriesState(),
    this.childCategoriesStateMap = const {},
  });

  final ProductCategoryCategoriesState topLevelCategoriesState;

  /// The key is the parent category id for the children
  final Map<String, ProductCategoryCategoriesState> childCategoriesStateMap;

  ProductCategoryCategoriesState getChildCategoriesStateOrThrow({
    required String parentId,
  }) =>
      childCategoriesStateMap[parentId] ??
      (throw StateError('The $parentId does not exist'));

  @override
  List<Object?> get props => [
        topLevelCategoriesState,
        childCategoriesStateMap,
      ];
}

class ProductCategoryInitial extends ProductCategoryState {
  const ProductCategoryInitial();
}

// Load top-level categories that has no parent

class ProductCategoryLoadTopLevelInProgress extends ProductCategoryState {
  const ProductCategoryLoadTopLevelInProgress();
}

class ProductCategoryLoadTopLevelMoreInProgress extends ProductCategoryState {
  const ProductCategoryLoadTopLevelMoreInProgress({
    required super.topLevelCategoriesState,
  });
}

class ProductCategoryLoadTopLevelSuccess extends ProductCategoryState {
  const ProductCategoryLoadTopLevelSuccess({
    required super.topLevelCategoriesState,
  });
}

class ProductCategoryLoadTopLevelFailure extends ProductCategoryState {
  const ProductCategoryLoadTopLevelFailure(this.exception);

  final ProductCategoryException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// Load sub-categories where they have parent

class ProductCategoryLoadChildInProgress extends ProductCategoryState {
  const ProductCategoryLoadChildInProgress({
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });
}

class ProductCategoryLoadChildMoreInProgress extends ProductCategoryState {
  const ProductCategoryLoadChildMoreInProgress({
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });
}

class ProductCategoryLoadChildSuccess extends ProductCategoryState {
  const ProductCategoryLoadChildSuccess({
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });
}

class ProductCategoryLoadChildFailure extends ProductCategoryState {
  const ProductCategoryLoadChildFailure(
    this.exception, {
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });

  final ProductCategoryException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// For category item actions (such as delete, update etc...)

class ProductCategoryActionInProgress extends ProductCategoryState {
  const ProductCategoryActionInProgress({
    required this.categoryId,
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });

  final String categoryId;

  @override
  List<Object?> get props => [categoryId, ...super.props];
}

class ProductCategoryActionSuccess extends ProductCategoryState {
  const ProductCategoryActionSuccess({
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });
}

class ProductCategoryActionFailure extends ProductCategoryState {
  const ProductCategoryActionFailure(
    this.exception, {
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });

  final ProductCategoryException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

// For creating category

class ProductCategoryCreateInProgress extends ProductCategoryState {
  const ProductCategoryCreateInProgress({
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });
}

class ProductCategoryCreateSuccess extends ProductCategoryState {
  const ProductCategoryCreateSuccess({
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });
}

class ProductCategoryCreateFailure extends ProductCategoryState {
  const ProductCategoryCreateFailure(
    this.exception, {
    required super.childCategoriesStateMap,
    required super.topLevelCategoriesState,
  });

  final ProductCategoryException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}
