import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/logic/user_cubit.dart';
import '../common/extensions/scaffold_messenger_ext.dart';
import '../common/localizations/app_localization_extension.dart';
import '../live_chat/data/live_chat_api.dart';
import '../live_chat/presentation/live_chat_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/presentation/settings_screen.dart';

@immutable
class DrawerItem {
  const DrawerItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isAuthRequired = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isAuthRequired;
}

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  List<DrawerItem> getNavigationItems(BuildContext context) => [
        DrawerItem(
          icon: Icons.message,
          title: context.loc.support,
          onTap: () => context.push(
            LiveChatScreen.routeName,
            extra: const LiveChatScreenArgs(
              connectionType: LiveChatConnectClientUser(),
            ),
          ),
          isAuthRequired: true,
        ),
        DrawerItem(
          icon: Icons.account_circle,
          title: context.loc.account,
          onTap: () => context.push(ProfileScreen.routeName),
          isAuthRequired: true,
        ),
        DrawerItem(
          icon: Icons.notifications,
          title: context.loc.notifications,
          onTap: () => context.push(NotificationsScreen.routeName),
          isAuthRequired: false,
        ),
        DrawerItem(
          icon: Icons.settings,
          title: context.loc.settings,
          onTap: () => context.push(SettingsScreen.routeName),
          isAuthRequired: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final items = getNavigationItems(context);
    return NavigationDrawer(
      selectedIndex: -1,
      onDestinationSelected: (value) {
        final item = items[value];
        context.pop();
        if (item.isAuthRequired) {
          final userCredential = context.read<UserCubit>().state.userCredential;
          if (userCredential == null) {
            ScaffoldMessenger.of(context).showSnackBarText(
              context.loc.youNeedToLoginFirst,
            );
            return;
          }
        }
        item.onTap();
      },
      children: [
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            final user = state.userCredential;
            return UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              currentAccountPicture: const FlutterLogo(),
              accountName: Text(
                user != null ? user.user.info.labName : context.loc.guestUser,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: user != null
                  ? Text(user.user.info.labOwnerName)
                  : const SizedBox.shrink(),
            );
          },
        ),
        ...items.map(
          (e) => NavigationDrawerDestination(
            icon: Icon(
              e.icon,
              semanticLabel: e.title,
            ),
            label: Text(e.title),
          ),
        ),
      ],
    );
  }
}
