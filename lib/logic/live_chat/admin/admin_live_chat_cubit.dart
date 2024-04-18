import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/live_chat/admin/admin_live_chat_repository.dart';
import '../../../data/live_chat/live_chat_exceptions.dart';
import '../../../data/live_chat/models/live_chat_room.dart';
import '../live_chat_cubit.dart';

part 'admin_live_chat_state.dart';

/// Responsible for managing the rooms for admin
/// Also see [LiveChatCubit]
class AdminLiveChatCubit extends Cubit<AdminLiveChatState> {
  AdminLiveChatCubit({
    required this.adminLiveChatRepository,
  }) : super(const AdminLiveChatInitial()) {
    initLoadRooms();
  }

  final AdminLiveChatRepository adminLiveChatRepository;

  static const _limit = 15;

  Future<void> initLoadRooms() async {
    try {
      emit(const AdminLiveChatLoadRoomsInProgress());
      final rooms = await adminLiveChatRepository.getRooms(
        page: 1,
        limit: _limit,
      );
      emit(AdminLiveChatLoadRoomsSuccess(
        roomsState: AdminLiveChatRoomsState(
          rooms: rooms,
          page: 1,
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
      final moreRooms = await adminLiveChatRepository.getRooms(
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

  Future<void> deleteRoom({
    required String roomId,
  }) async {
    try {
      emit(AdminLiveChatActionInProgress(
        roomsState: state.roomsState,
        roomId: roomId,
      ));
      await adminLiveChatRepository.deleteRoomById(roomId: roomId);
      final rooms = [...state.roomsState.rooms]..removeWhere(
          (room) => room.id == roomId,
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
      await adminLiveChatRepository.deleteAllRooms();
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
