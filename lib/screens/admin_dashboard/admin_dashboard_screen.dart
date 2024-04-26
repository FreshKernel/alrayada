import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/live_chat/admin/admin_live_chat_cubit.dart';
import '../../utils/extensions/scaffold_messenger_ext.dart';
import '../../widgets/responsive_navbar.dart';
import '../dashboard/tab_item.dart';
import 'tabs/live_chat/admin_live_chat_tab.dart';
import 'tabs/product_hub/admin_product_hub_tab.dart';
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
          id: AdminProductHubTab.id,
          label: context.loc.productHub,
          body: const AdminProductHubTab(),
          title: context.loc.productHub,
          icon: Icon(
            isCupertino(context) ? CupertinoIcons.bag_fill : Icons.category,
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
          id: AdminLiveChatTab.id,
          label: context.loc.chat,
          body: const AdminLiveChatTab(),
          title: context.loc.chat,
          icon: Icon(
            isCupertino(context) ? CupertinoIcons.chat_bubble : Icons.chat,
          ),
          actionsBuilder: (context) => [
            BlocConsumer<AdminLiveChatCubit, AdminLiveChatState>(
              listener: (context, state) {
                if (state is AdminLiveChatDeleteAllRoomsFailure) {
                  ScaffoldMessenger.of(context)
                      .showSnackBarText(context.loc.unknownErrorWithMsg(
                    state.exception.message,
                  ));
                }
              },
              builder: (context, state) {
                return IconButton(
                  color: Theme.of(context).colorScheme.error,
                  onPressed: state is AdminLiveChatDeleteAllRoomsInProgress
                      ? null
                      : () =>
                          context.read<AdminLiveChatCubit>().deleteAllRooms(),
                  icon: Icon(
                    isCupertino(context) ? CupertinoIcons.delete : Icons.delete,
                    semanticLabel: context.loc.delete,
                  ),
                );
              },
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
