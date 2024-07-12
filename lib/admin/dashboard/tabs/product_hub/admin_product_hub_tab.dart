import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../common/localizations/app_localization_extension.dart';
import 'categories/admin_categories_tab.dart';
import 'products/admin_products_tab.dart';

/// A screen that has both [AdminProductsTab] and [AdminCategoriesTab]
/// using [TabBarView]
class AdminProductHubTab extends StatelessWidget {
  const AdminProductHubTab({super.key});

  static const id = 'productHubTab';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Hardcoded
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  isCupertino(context) ? CupertinoIcons.folder : Icons.folder,
                ),
                text: context.loc.categories,
              ),
              Tab(
                icon: Icon(
                  isCupertino(context)
                      ? CupertinoIcons.list_bullet
                      : Icons.list,
                ),
                text: context.loc.products,
              ),
            ],
          ),
          const Expanded(
            child: TabBarView(
              children: [
                AdminCategoriesTab(),
                AdminProductsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
