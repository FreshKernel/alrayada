import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../logic/products/category/product_category_cubit.dart';
import '../../../../../utils/extensions/scaffold_messenger_ext.dart';
import '../../../../../widgets/errors/unknown_error.dart';
import '../../../../../widgets/no_data_found.dart';
import '../../../../../widgets/scroll_edge_detector.dart';
import 'admin_add_edit_category_dialog.dart';
import 'admin_category_tile.dart';

class AdminCategoriesTab extends StatelessWidget {
  const AdminCategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        BlocBuilder<ProductCategoryCubit, ProductCategoryState>(
          builder: (context, state) {
            return OutlinedButton.icon(
              onPressed: state is ProductCategoryCreateInProgress
                  ? null
                  : () {
                      AdminAddEditCategoryDialog.show(
                        context: context,
                        initialCategory: null,
                        onSubmit: (data) {
                          context.read<ProductCategoryCubit>().createCategory(
                                parentId: null,
                                name: data.name,
                                description: data.description,
                                imageFile: data.imageFileOrThrow,
                              );
                        },
                      );
                    },
              icon: Icon(context.platformIcons.add),
              label: Text(context.loc.add),
            );
          },
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BlocConsumer<ProductCategoryCubit, ProductCategoryState>(
            listener: (context, state) {
              if (state is ProductCategoryCreateFailure) {
                ScaffoldMessenger.of(context).showSnackBarText(
                  context.loc.unknownErrorWithMsg(state.exception.toString()),
                );
                return;
              }
              if (state is ProductCategoryActionFailure) {
                ScaffoldMessenger.of(context).showSnackBarText(
                  context.loc.unknownErrorWithMsg(state.exception.toString()),
                );
                return;
              }
            },
            builder: (context, state) {
              if (state is ProductCategoryTopLevelLoadInProgress) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (state is ProductCategoryTopLevelLoadFailure) {
                return UnknownError(
                  onTryAgain: () => context
                      .read<ProductCategoryCubit>()
                      .loadTopLevelCategories(),
                );
              }
              final categories = state.topLevelCategoriesState.categories;
              if (categories.isEmpty) {
                return NoDataFound(
                  onRefresh: () => context
                      .read<ProductCategoryCubit>()
                      .loadTopLevelCategories(),
                );
              }

              return RefreshIndicator.adaptive(
                onRefresh: () async {
                  await context
                      .read<ProductCategoryCubit>()
                      .loadTopLevelCategories();
                },
                child: ScrollEdgeDetector(
                  onBottom: () => context
                      .read<ProductCategoryCubit>()
                      .loadMoreTopLevelCategories(),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    padding: const EdgeInsets.all(12),
                    itemCount:
                        state is ProductCategoryTopLevelLoadMoreInProgress
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
                      return AdminCategoryTile(
                        category: category,
                        parentId: null,
                        isLoading: state is ProductCategoryActionInProgress &&
                            state.categoryId == category.id,
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
