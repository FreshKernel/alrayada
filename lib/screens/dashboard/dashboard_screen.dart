import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';

import 'cupertino/cupertino_dashboard.dart';
import 'material/material_dashboard.dart';
import 'navigation_item.dart';
import 'pages/cart_page.dart';
import 'pages/categories_page.dart';
import 'pages/home_page.dart';
import 'pages/orders_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<MaterialScaffoldDashboardState> _materialScaffoldKey =
      GlobalKey();
  final GlobalKey<CupertinoScaffoldDashboardState> _cupertinoScaffoldKey =
      GlobalKey();

  List<NavigationItem> get _items => [
        NavigationItem(
          label: context.loc.home,
          body: const HomePage(
            key: PageStorageKey('Home'),
          ),
          title: context.loc.home,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.home
                : Icons.dashboard_outlined,
            semanticLabel: context.loc.home,
          ),
        ),
        NavigationItem(
          label: context.loc.categories,
          body: const CategoriesPage(
            key: PageStorageKey('Categories'),
          ),
          title: context.loc.categories,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.list_bullet
                : Icons.category_outlined,
            semanticLabel: context.loc.categories,
          ),
        ),
        NavigationItem(
          label: context.loc.shoppingCart,
          body: const CartPage(
            key: PageStorageKey('Cart'),
          ),
          title: context.loc.shoppingCart,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.shopping_cart
                : Icons.shopping_bag_outlined,
            semanticLabel: context.loc.shoppingCart,
          ),
        ),
        NavigationItem(
          label: context.loc.orders,
          body: const OrdersPage(
            key: PageStorageKey('Orders'),
          ),
          title: context.loc.orders,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.square_stack_3d_down_right
                : Icons.shopping_basket,
            semanticLabel: context.loc.orders,
          ),
        ),
        NavigationItem(
          label: context.loc.account,
          body: const CategoriesPage(
            key: PageStorageKey('Account'),
          ),
          title: context.loc.account,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.person_alt_circle_fill
                : Icons.account_box_rounded,
            semanticLabel: context.loc.account,
          ),
        ),
      ];

  void navigateToNewItem(int newIndex) {
    if (isCupertino(context)) {
      _cupertinoScaffoldKey.currentState!.navigateToItem(newIndex);
      return;
    }
    _materialScaffoldKey.currentState!.navigateToItem(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (isCupertino(context)) {
      return CupertinoScaffoldDashboard(
        navigationItems: _items,
      );
    }
    return MaterialScaffoldDashboard(
      navigationItems: _items,
    );
  }
}
