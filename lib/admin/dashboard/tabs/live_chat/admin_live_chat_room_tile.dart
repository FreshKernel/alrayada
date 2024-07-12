import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/localizations/app_localization_extension.dart';
import '../../../../live_chat/data/live_chat_api.dart';
import '../../../../live_chat/data/models/live_chat_room.dart';
import '../../../../live_chat/presentation/live_chat_screen.dart';
import '../../../live_chat/logic/admin_live_chat_cubit.dart';

class AdminLiveChatRoomTile extends StatelessWidget {
  const AdminLiveChatRoomTile({
    required this.room,
    required this.index,
    required this.isLoading,
    super.key,
  });

  final LiveChatRoom room;
  final int index;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push(
        LiveChatScreen.routeName,
        extra: LiveChatScreenArgs(
          connectionType:
              LiveChatConnectAdminUser(roomClientUserId: room.roomClientUserId),
        ),
      ),
      leading: CircleAvatar(
        child: Text(
          (index + 1).toString(),
        ),
      ),
      title: Text(room.roomClientUserId.toString()),
      subtitle: Text(room.id.toString()),
      trailing: IconButton(
        color: Theme.of(context).colorScheme.error,
        onPressed: isLoading
            ? null
            : () =>
                context.read<AdminLiveChatCubit>().deleteRoomById(id: room.id),
        icon: Icon(
          isCupertino(context) ? CupertinoIcons.delete : Icons.delete,
          semanticLabel: context.loc.delete,
        ),
      ),
    );
  }
}
