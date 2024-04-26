import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/live_chat/admin/admin_live_chat_api.dart';
import '../../../data/live_chat/live_chat_exceptions.dart';
import '../../../data/live_chat/models/live_chat_room.dart';
import '../live_chat_cubit.dart';

part 'admin_live_chat_state.dart';

/// Responsible for managing the rooms for admin
/// Also see [LiveChatCubit]
class AdminLiveChatCubit extends Cubit<AdminLiveChatState> {
  AdminLiveChatCubit({
    required this.adminLiveChatApi,
  }) : super(const AdminLiveChatInitial()) {
    loadRooms();
  }

  final AdminLiveChatApi adminLiveChatApi;

  static const _limit = 15;

  Future<void> loadRooms() async {
    try {
      emit(const AdminLiveChatLoadRoomsInProgress());
      final rooms = await adminLiveChatApi.getRooms(
        page: 1,
        limit: _limit,
      );
      emit(AdminLiveChatLoadRoomsSuccess(
        roomsState: AdminLiveChatRoomsState(
          rooms: rooms,
          hasReachedLastPage: rooms.isEmpty,
        ),
      ));
    } on LiveChatException catch (e) {
      emit(AdminLiveChatLoadRoomsFailure(e));
    }
  }

  Future<void> loadMoreRooms() async {
    try {
      if (state.roomsState.hasReachedLastPage) {
        return;
      }
      if (state is AdminLiveChatLoadMoreRoomsInProgress) {
        // In case if the function called more than once
        return;
      }
      emit(AdminLiveChatLoadMoreRoomsInProgress(
        roomsState: state.roomsState.copyWith(
          page: state.roomsState.page + 1,
        ),
      ));
      final moreRooms = await adminLiveChatApi.getRooms(
        page: state.roomsState.page,
        limit: _limit,
      );
      emit(AdminLiveChatLoadRoomsSuccess(
        roomsState: state.roomsState.copyWith(
          rooms: [
            ...state.roomsState.rooms,
            ...moreRooms,
          ],
          hasReachedLastPage: moreRooms.isEmpty,
        ),
      ));
    } on LiveChatException catch (e) {
      emit(AdminLiveChatLoadRoomsFailure(e));
    }
  }

  Future<void> deleteRoomById({
    required String id,
  }) async {
    try {
      emit(AdminLiveChatActionInProgress(
        roomsState: state.roomsState,
        roomId: id,
      ));
      await adminLiveChatApi.deleteRoomById(roomId: id);
      final rooms = [...state.roomsState.rooms]..removeWhere(
          (room) => room.id == id,
        );
      emit(AdminLiveChatActionSuccess(
        roomsState: state.roomsState.copyWith(
          rooms: rooms,
        ),
      ));
    } on LiveChatException catch (e) {
      emit(AdminLiveChatActionFailure(e, roomsState: state.roomsState));
    }
  }

  Future<void> deleteAllRooms() async {
    try {
      emit(AdminLiveChatDeleteAllRoomsInProgress(
        roomsState: state.roomsState,
      ));
      await adminLiveChatApi.deleteAllRooms();
      emit(AdminLiveChatDeleteAllRoomsSuccess(
        roomsState: state.roomsState.copyWith(
          rooms: [],
        ),
      ));
    } on LiveChatException catch (e) {
      emit(AdminLiveChatDeleteAllRoomsFailure(e, roomsState: state.roomsState));
    }
  }
}
