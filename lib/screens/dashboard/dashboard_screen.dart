import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/settings/settings_cubit.dart';
import '../../utils/extensions/scaffold_messenger_ext.dart';
import '../../widgets/responsive_navbar.dart';
import '../live_chat/live_chat_screen.dart';
import '../onboarding/onboarding_screen.dart';
import 'dashboard_drawer.dart';
import 'tab_item.dart';
import 'tabs/account_tab.dart';
import 'tabs/cart_tab.dart';
import 'tabs/categories_tab.dart';
import 'tabs/home/home_tab.dart';
import 'tabs/orders/orders_tab.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// The [PageStorageKey] is used to save the scroll state, the value
  /// has to be unique but it doesn't has to be the id of the tab in order to work
  List<TabItem> get _tabs => [
        TabItem(
          id: HomeTab.id,
          label: context.loc.home,
          body: const HomeTab(
            key: PageStorageKey(HomeTab.id),
          ),
          title: context.loc.home,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.home
                : Icons.dashboard_outlined,
            semanticLabel: context.loc.home,
          ),
          actionButtonBuilder: (context) => FloatingActionButton(
            onPressed: () {
              if (context.read<AuthCubit>().state.userCredential == null) {
                ScaffoldMessenger.of(context).showSnackBarText(
                  context.loc.youNeedToLoginFirst,
                );
                return;
              }
              context.push(LiveChatScreen.routeName);
            },
            child: Icon(
              isCupertino(context)
                  ? CupertinoIcons.chat_bubble_fill
                  : Icons.chat,
            ),
          ),
          actionsBuilder: (context) => [
            PlatformIconButton(
              material: (context, platform) => MaterialIconButtonData(
                tooltip: context.loc.support,
              ),
              onPressed: () => context.push(LiveChatScreen.routeName),
              icon: Icon(
                isCupertino(context)
                    ? CupertinoIcons.chat_bubble_fill
                    : Icons.chat,
              ),
            ),
            PlatformIconButton(
              material: (context, platform) => MaterialIconButtonData(
                tooltip: context.loc.orders,
              ),
              onPressed: () => _navigateToTabById(CartTab.id),
              icon: Icon(
                isCupertino(context)
                    ? CupertinoIcons.square_stack_3d_down_right
                    : Icons.shopping_cart,
              ),
            ),
          ],
        ),
        TabItem(
          id: CategoriesTab.id,
          label: context.loc.categories,
          body: const CategoriesTab(
            key: PageStorageKey(CategoriesTab.id),
          ),
          title: context.loc.categories,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.list_bullet
                : Icons.category_outlined,
            semanticLabel: context.loc.categories,
          ),
        ),
        TabItem(
          id: CartTab.id,
          label: context.loc.shoppingCart,
          body: const CartTab(
            key: PageStorageKey(CartTab.id),
          ),
          title: context.loc.shoppingCart,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.shopping_cart
                : Icons.shopping_bag_outlined,
            semanticLabel: context.loc.shoppingCart,
          ),
        ),
        TabItem(
          id: OrdersTab.id,
          label: context.loc.orders,
          body: const OrdersTab(
            key: PageStorageKey(OrdersTab.id),
          ),
          title: context.loc.orders,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.square_stack_3d_down_right
                : Icons.shopping_basket,
            semanticLabel: context.loc.orders,
          ),
        ),
        TabItem(
          id: AccountTab.id,
          label: context.loc.account,
          body: AccountTab(
            navigateToTab: _navigateToTabById,
            key: const PageStorageKey(AccountTab.id),
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

  void _navigateToTabById(String newTabId) {
    final newIndex = _tabs.indexWhere((tab) => tab.id == newTabId);
    _navigateToTab(newIndex);
  }

  void _navigateToTab(int newIndex) => setState(() => _currentIndex = newIndex);

  var _currentIndex = 0;
  final _pageStorageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsCubit, SettingsState, bool>(
      selector: (state) => state.showOnBoardingScreen,
      builder: (context, showOnBoardingScreen) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 330),
          transitionBuilder: (child, animation) {
            // This animation is from flutter.dev example
            final tween = Tween(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(
              CurveTween(curve: Curves.ease),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          child: showOnBoardingScreen
              ? const OnBoardingScreen()
              : ResponsiveNavbar(
                  tabs: _tabs,
                  currentIndex: _currentIndex,
                  onDestinationSelected: _navigateToTab,
                  drawer: const DashboardDrawer(),
                  pageStorageBucket: _pageStorageBucket,
                ),
        );
      },
    );
  }
}
