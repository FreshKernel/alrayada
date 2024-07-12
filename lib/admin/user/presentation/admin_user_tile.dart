import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/data/models/user.dart';
import '../../../common/localizations/app_localization_extension.dart';
import '../../../live_chat/data/live_chat_api.dart';
import '../../../live_chat/presentation/live_chat_screen.dart';
import '../logic/admin_user_cubit.dart';
import 'admin_send_notification_dialog.dart';

/// The admin can view all the users data
class AdminUserTile extends StatelessWidget {
  const AdminUserTile({
    required this.user,
    required this.index,
    required this.isLoading,
    super.key,
  });

  final User user;
  final int index;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => showAdaptiveDialog(
        context: context,
        builder: (context) => _AdminUserTileDataDialog(
          user: user,
        ),
      ),
      title: Text(user.email),
      subtitle: Text('#${index + 1} - ${user.info.labName}'),
      leading: Icon(
        user.isAccountActivated
            ? (isCupertino(context)
                ? CupertinoIcons.checkmark_shield_fill
                : Icons.verified_user)
            : (isCupertino(context)
                ? CupertinoIcons.bubble_left_bubble_right
                : Icons.rate_review),
      ),
      trailing: PopupMenuButton(
        child: isLoading ? const CircularProgressIndicator.adaptive() : null,
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem(
            child: Text(user.isAccountActivated
                ? context.loc.deactivate
                : context.loc.activate),
            onTap: () => context.read<AdminUserCubit>().setAccountActivated(
                  userId: user.id,
                  value: !user.isAccountActivated,
                ),
          ),
          PopupMenuItem(
            child: Text(context.loc.delete),
            onTap: () => context.read<AdminUserCubit>().deleteUserAccount(
                  userId: user.id,
                ),
          ),
          PopupMenuItem(
            child: Text(context.loc.sendNotification),
            onTap: () => showAdaptiveDialog(
              context: context,
              builder: (context) => AdminSendNotificationToUserDialog(
                userId: user.id,
              ),
            ),
          ),
          // TODO: Right now when admin open a chat with a user,
          // the room will created but will not updated in the AdminLiveChatCubit
          // state, instead admin have to refresh in order to see the update
          PopupMenuItem(
            child: Text(context.loc.chat),
            onTap: () => context.push(
              LiveChatScreen.routeName,
              extra: LiveChatScreenArgs(
                connectionType: LiveChatConnectAdminUser(
                  roomClientUserId: user.id,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminUserTileDataDialog extends StatelessWidget {
  const _AdminUserTileDataDialog({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(context.loc.data),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: '${context.loc.labOwnerName}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${user.info.labOwnerName}\n',
                ),
                TextSpan(
                  text: '${context.loc.labOwnerPhoneNumber}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${user.info.labOwnerPhoneNumber}\n',
                ),
                TextSpan(
                  text: '${context.loc.labPhoneNumber}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '${user.info.labPhoneNumber}\n',
                ),
                TextSpan(
                  text: '${context.loc.city}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      '${user.info.city.getTranslatedCityName(localizations: context.loc)}\n',
                ),
                TextSpan(
                  text: '${context.loc.emailAddress}: ',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: user.email,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        PlatformDialogAction(
          onPressed: context.pop,
          child: Text(context.loc.close),
        ),
      ],
    );
  }
}
