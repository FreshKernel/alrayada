import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/presentation/widgets/errors/unknown_error.dart';
import '../../common/presentation/widgets/no_data_found.dart';
import '../../common/presentation/widgets/scroll_edge_detector.dart';
import '../logic/category/product_category_cubit.dart';
import '../../dashboard/tabs/category_tile.dart';

class CategoriesTab extends StatelessWidget {
  const CategoriesTab({super.key});

  static const id = 'categoriesTab';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
      builder: (context, state) {
        if (state is ProductCategoryLoadTopLevelInProgress) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is ProductCategoryLoadTopLevelFailure) {
          return UnknownError(
            onTryAgain: () =>
                context.read<ProductCategoryCubit>().loadTopLevelCategories(),
          );
        }
        final categories = state.topLevelCategoriesState.categories;
        if (categories.isEmpty) {
          return NoDataFound(
            onRefresh: () =>
                context.read<ProductCategoryCubit>().loadTopLevelCategories(),
          );
        }

        return RefreshIndicator.adaptive(
          onRefresh: () async {
            await context.read<ProductCategoryCubit>().loadTopLevelCategories();
          },
          child: ScrollEdgeDetector(
            onBottom: () => context
                .read<ProductCategoryCubit>()
                .loadMoreTopLevelCategories(),
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
              itemCount: state is ProductCategoryLoadTopLevelMoreInProgress
                  ? categories.length + 1
                  : categories.length,
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  // Loading indicator when loading more items
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                final category = categories[index];
                return CategoryTile(
                  category: category,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
