import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';

import '../../logic/settings/settings_cubit.dart';
import '../onboarding/onboarding_screen.dart';
import 'dashboard_drawer.dart';
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

  void _navigateToNewItem(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  var _currentIndex = 0;
  final _pageStorageBucket = PageStorageBucket();

  bool _isNavRailBar(Size size, AppLayoutMode layoutMode) {
    switch (layoutMode) {
      //  Might want needs to be updated
      case AppLayoutMode.auto:
        return size.width >= 480;
      case AppLayoutMode.small:
        return false;
      case AppLayoutMode.large:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.layoutMode != current.layoutMode ||
          previous.showOnBoardingScreen != current.showOnBoardingScreen,
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 330),
          transitionBuilder: (child, animation) {
            // This animation is from flutter.dev example
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          child: state.showOnBoardingScreen
              ? const OnBoardingScreen()
              : Scaffold(
                  drawer: const DashboardDrawer(),
                  appBar: AppBar(
                    title: Text(_items[_currentIndex].label),
                    actions:
                        _items[_currentIndex].actionsBuilder?.call(context),
                  ),
                  body: SafeArea(
                    child: Builder(
                      builder: (context) {
                        final bodyWidget = PageStorage(
                          bucket: _pageStorageBucket,
                          child: _items[_currentIndex].body,
                        );
                        if (!_isNavRailBar(
                            MediaQuery.sizeOf(context), state.layoutMode)) {
                          return bodyWidget;
                        }
                        return Row(
                          children: [
                            NavigationRail(
                              onDestinationSelected: _navigateToNewItem,
                              labelType: NavigationRailLabelType.all,
                              destinations: _items.map((e) {
                                return e.toNavigationRailDestination();
                              }).toList(),
                              selectedIndex: _currentIndex,
                            ),
                            Expanded(
                              child: widget,
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  bottomNavigationBar: Builder(
                    builder: (context) {
                      if (_isNavRailBar(
                          MediaQuery.sizeOf(context), state.layoutMode)) {
                        return const SizedBox.shrink();
                      }
                      return NavigationBar(
                        selectedIndex: _currentIndex,
                        onDestinationSelected: _navigateToNewItem,
                        destinations: _items.map((e) {
                          return e.toNavigationDestination();
                        }).toList(),
                      );
                    },
                  ),
                  floatingActionButton:
                      _items[_currentIndex].actionButtonBuilder?.call(context),
                ),
        );
      },
    );
  }
}
