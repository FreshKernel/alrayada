import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../../data/product/category/product_category.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../logic/products/category/product_category_cubit.dart';
import '../../../../../widgets/dialog/ok_cancel_dialog.dart';
import '../../../../../widgets/my_image.dart';
import 'admin_add_edit_category_dialog.dart';
import 'admin_category_details_screen.dart';

class AdminCategoryTile extends StatelessWidget {
  const AdminCategoryTile({
    required this.category,
    required this.parentId,
    required this.isLoading,
    super.key,
  });

  final ProductCategory category;

  /// If this a sub-category, then pass the parent category id of this child
  final String? parentId;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GestureDetector(
        onTap: () {
          context.read<ProductCategoryCubit>().loadSubCategories(
                parentId: category.id,
                isSkipIfLoaded: true,
              );
          context.push(AdminCategoryDetailsScreen.routeName, extra: category);
        },
        child: GridTile(
          header: GridTileBar(
            title: Text(
              category.name,
              maxLines: 1,
            ),
            subtitle: Text(
              category.description,
              maxLines: 1,
            ),
            leading: IconButton(
              tooltip: context.loc.edit,
              icon: Icon(context.platformIcons.edit),
              onPressed: isLoading
                  ? null
                  : () {
                      AdminAddEditCategoryDialog.show(
                        context: context,
                        initialCategory: category,
                        onSubmit: (data) {
                          context
                              .read<ProductCategoryCubit>()
                              .updateCategoryById(
                                id: category.id,
                                name: data.name,
                                description: data.description,
                                newImageFile: data.imageFile,
                                parentId: parentId,
                              );
                        },
                      );
                    },
            ),
            trailing: IconButton(
              color: Theme.of(context).colorScheme.error,
              tooltip: context.loc.delete,
              icon: Icon(context.platformIcons.delete),
              onPressed: isLoading
                  ? null
                  : () async {
                      final productCategoryBloc =
                          context.read<ProductCategoryCubit>();
                      final isDeletionConfirmed = await showOkCancelDialog(
                        context: context,
                        title: Text(context.loc.delete),
                        content: Text(
                          context.loc.deleteCategoryConfirmation,
                        ),
                        ok: Text(context.loc.delete),
                      );
                      if (!isDeletionConfirmed) {
                        return;
                      }
                      productCategoryBloc.deleteCategoryById(
                        id: category.id,
                        parentId: parentId,
                      );
                    },
            ),
            backgroundColor: Colors.black54,
          ),
          child: MyImage(
            imageProvider: CachedNetworkImageProvider(category.imageUrls.first),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
