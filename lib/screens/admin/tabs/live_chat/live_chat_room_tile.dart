import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/live_chat/live_chat_repository.dart';
import '../../../../data/live_chat/models/live_chat_room.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../logic/live_chat/admin/admin_live_chat_cubit.dart';
import '../../../live_chat/live_chat_screen.dart';

class LiveChatRoomTile extends StatelessWidget {
  const LiveChatRoomTile({
    required this.room,
    required this.index,
    super.key,
  });

  final LiveChatRoom room;
  final int index;

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
        onPressed: () =>
            context.read<AdminLiveChatCubit>().deleteRoom(roomId: room.id),
        icon: Icon(
          isCupertino(context) ? CupertinoIcons.delete : Icons.delete,
          semanticLabel: context.loc.delete,
        ),
      ),
    );
  }
}
