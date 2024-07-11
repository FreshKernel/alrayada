import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../../data/product/category/product_category.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../logic/products/category/product_category_cubit.dart';
import '../../../../../widgets/errors/unknown_error.dart';
import '../../../../../widgets/no_data_found.dart';
import '../../../../../widgets/scroll_edge_detector.dart';
import 'admin_add_edit_category_dialog.dart';
import 'admin_category_tile.dart';

class AdminCategoryDetailsScreen extends StatelessWidget {
  const AdminCategoryDetailsScreen({
    required this.category,
    super.key,
  });

  static const routeName = '/adminCategoryDetails';

  final ProductCategory category;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
        builder: (context, state) {
          if (state is ProductCategoryLoadChildInProgress) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is ProductCategoryLoadChildFailure) {
            return UnknownError(
              onTryAgain: () => context
                  .read<ProductCategoryCubit>()
                  .loadChildCategories(parentId: category.id),
            );
          }
          final childCategories = state
              .getChildCategoriesStateOrThrow(
                parentId: category.id,
              )
              .categories;
          if (childCategories.isEmpty) {
            return NoDataFound(
              onRefresh: () =>
                  context.read<ProductCategoryCubit>().loadTopLevelCategories(),
            );
          }
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              await context
                  .read<ProductCategoryCubit>()
                  .loadChildCategories(parentId: category.id);
            },
            child: ScrollEdgeDetector(
              onBottom: () => context
                  .read<ProductCategoryCubit>()
                  .loadMoreChildCategories(parentId: category.id),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                ),
                padding: const EdgeInsets.all(12),
                itemCount: state is ProductCategoryLoadChildMoreInProgress
                    ? childCategories.length + 1
                    : childCategories.length,
                itemBuilder: (context, index) {
                  if (index == childCategories.length) {
                    // Loading indicator when loading more items
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  final childCategory = childCategories[index];
                  return AdminCategoryTile(
                    category: childCategory,
                    parentId: category.id,
                    isLoading: state is ProductCategoryActionInProgress &&
                        state.categoryId == childCategory.id,
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AdminAddEditCategoryDialog.show(
            context: context,
            initialCategory: null,
            onSubmit: (data) {
              context.read<ProductCategoryCubit>().createCategory(
                    parentId: category.id,
                    name: data.name,
                    description: data.description,
                    imageFile: data.imageFileOrThrow,
                  );
            },
          );
        },
        tooltip: context.loc.add,
        child: BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
          builder: (context, state) {
            if (state is ProductCategoryCreateInProgress) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            return Icon(context.platformIcons.add);
          },
        ),
      ),
    );
  }
}
