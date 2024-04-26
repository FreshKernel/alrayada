import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../logic/live_chat/admin/admin_live_chat_cubit.dart';
import '../../../../utils/extensions/scaffold_messenger_ext.dart';
import '../../../../widgets/errors/unknown_error.dart';
import '../../../../widgets/no_data_found.dart';
import '../../../../widgets/scroll_edge_detector.dart';
import 'admin_live_chat_room_tile.dart';

class AdminLiveChatTab extends StatelessWidget {
  const AdminLiveChatTab({super.key});

  static const id = 'liveChatTab';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminLiveChatCubit, AdminLiveChatState>(
      listener: (context, state) {
        if (state is AdminLiveChatActionFailure) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.unknownErrorWithMsg(state.exception.toString()),
          );
        }
      },
      builder: (context, state) {
        if (state is AdminLiveChatLoadRoomsInProgress) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is AdminLiveChatLoadRoomsFailure) {
          return UnknownError(
            onTryAgain: () => context.read<AdminLiveChatCubit>().loadRooms(),
          );
        }
        final rooms = state.roomsState.rooms;
        if (rooms.isEmpty) {
          return NoDataFound(
            onRefresh: () => context.read<AdminLiveChatCubit>().loadRooms(),
          );
        }
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            await context.read<AdminLiveChatCubit>().loadRooms();
          },
          child: ScrollEdgeDetector(
            // TODO: The pagiantion is not tested yet.
            onBottom: () => context.read<AdminLiveChatCubit>().loadMoreRooms(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: state is AdminLiveChatLoadMoreRoomsInProgress
                  ? rooms.length + 1
                  : rooms.length,
              itemBuilder: (context, index) {
                if (index == rooms.length) {
                  // Loading indicator when loading more items
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                final room = rooms[index];
                return AdminLiveChatRoomTile(
                  room: room,
                  index: index,
                  isLoading: state is AdminLiveChatActionInProgress &&
                      state.roomId == room.id,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
