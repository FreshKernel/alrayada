import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../account_data/account_data_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/settings_screen.dart';
import '../support/support_screen.dart';

class DashboardDrawer extends StatelessWidget {
  const DashboardDrawer({super.key});

  Widget _buildItem({
    required BuildContext context,
    required IconData leadingIcon,
    required String title,
    required VoidCallback onTap,
    bool authenticationRequired = false,
  }) =>
      Semantics(
        label: '$title ${context.loc.item}',
        child: ListTile(
          leading: Icon(
            leadingIcon,
            semanticLabel: title,
          ),
          title: Text(title),
          onTap: () {
            context.pop();
            if (authenticationRequired) {
              final userAuthenticatedResponse =
                  context.read<AuthCubit>().state.userCredential;
              if (userAuthenticatedResponse == null) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.loc.youNeedToLoginFirst),
                  ),
                );
                return;
              }
            }
            onTap();
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Required
        children: [
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              final user = state.userCredential;
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                currentAccountPicture: const FlutterLogo(),
                accountName: Text(
                  user != null ? user.user.data.labName : context.loc.guestUser,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: user != null
                    ? Text(user.user.data.labOwnerName)
                    : const SizedBox.shrink(),
              );
            },
          ),
          _buildItem(
            context: context,
            leadingIcon: Icons.message,
            title: context.loc.support,
            onTap: () => context.push(SupportScreen.routeName),
            authenticationRequired: true,
          ),
          _buildItem(
            context: context,
            leadingIcon: Icons.account_circle,
            title: context.loc.account,
            onTap: () => context.push(AccountDataScreen.routeName),
            authenticationRequired: true,
          ),
          _buildItem(
            context: context,
            leadingIcon: Icons.notifications,
            title: context.loc.notifications,
            onTap: () => context.push(NotificationsScreen.routeName),
            authenticationRequired: false,
          ),
          _buildItem(
            context: context,
            leadingIcon: Icons.settings,
            title: context.loc.settings,
            onTap: () => context.push(SettingsScreen.routeName),
            authenticationRequired: false,
          ),
        ],
      ),
    );
  }
}
