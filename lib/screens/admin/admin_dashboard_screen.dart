import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/responsive_navbar.dart';
import '../dashboard/tab_item.dart';
import 'tabs/live_chat/live_chat_tab.dart';
import 'tabs/users/admin_users_tab.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  static const routeName = '/adminDashboard';

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<TabItem> get _tabs => [
        TabItem(
          id: AdminUsersTab.id,
          label: context.loc.users,
          body: const AdminUsersTab(
            key: PageStorageKey(AdminUsersTab.id),
          ),
          title: context.loc.users,
          icon: Icon(
            isCupertino(context) ? CupertinoIcons.person : Icons.person,
          ),
        ),
        TabItem(
          id: 'Categories',
          label: context.loc.categories,
          body: const Text('Categories'),
          title: context.loc.categories,
          icon: Icon(
            isCupertino(context) ? CupertinoIcons.folder : Icons.folder,
          ),
        ),
        TabItem(
          id: 'Orders',
          label: context.loc.orders,
          body: const Text('Orders'),
          title: context.loc.orders,
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.shopping_cart
                : Icons.shopping_cart,
          ),
        ),
        TabItem(
          id: LiveChatTab.id,
          label: context.loc.chat,
          body: const LiveChatTab(),
          title: context.loc.chat,
          icon: Icon(
            isCupertino(context) ? CupertinoIcons.chat_bubble : Icons.chat,
          ),
          // TODO: Add delete all chat rooms button
          actionsBuilder: (context) => [
            IconButton(
              color: Theme.of(context).colorScheme.error,
              onPressed: () => throw UnimplementedError('Not yet'),
              icon: Icon(
                isCupertino(context) ? CupertinoIcons.delete : Icons.delete,
                semanticLabel: context.loc.delete,
              ),
            ),
          ],
        ),
        TabItem(
          id: 'Offers',
          label: 'Offers',
          body: const Text('Offers'),
          title: 'Offers',
          icon: Icon(
            isCupertino(context)
                ? CupertinoIcons.money_dollar
                : Icons.attach_money,
          ),
        ),
        TabItem(
          id: 'Products',
          label: 'Products',
          body: const Text('Products'),
          title: 'Products',
          icon: Icon(
            isCupertino(context) ? CupertinoIcons.list_bullet : Icons.list,
          ),
        ),
      ];

  void _navigateToTab(int newIndex) => setState(() => _currentIndex = newIndex);

  var _currentIndex = 0;
  final _pageStorageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavbar(
      tabs: _tabs,
      currentIndex: _currentIndex,
      onDestinationSelected: _navigateToTab,
      pageStorageBucket: _pageStorageBucket,
    );
  }
}
