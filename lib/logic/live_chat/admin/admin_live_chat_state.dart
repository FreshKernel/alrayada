part of 'admin_live_chat_cubit.dart';

@immutable
class AdminLiveChatRoomsState extends Equatable {
  const AdminLiveChatRoomsState({
    this.rooms = const [],
    this.page = 1,
    this.hasReachedLastPage = false,
  });

  final List<LiveChatRoom> rooms;
  final int page;
  final bool hasReachedLastPage;

  @override
  List<Object?> get props => [
        rooms,
        page,
        hasReachedLastPage,
      ];

  AdminLiveChatRoomsState copyWith({
    List<LiveChatRoom>? rooms,
    int? page,
    bool? hasReachedLastPage,
  }) {
    return AdminLiveChatRoomsState(
      rooms: rooms ?? this.rooms,
      page: page ?? this.page,
      hasReachedLastPage: hasReachedLastPage ?? this.hasReachedLastPage,
    );
  }
}

@immutable
sealed class AdminLiveChatState extends Equatable {
  const AdminLiveChatState({
    this.roomsState = const AdminLiveChatRoomsState(),
  });

  final AdminLiveChatRoomsState roomsState;

  @override
  List<Object?> get props => [roomsState];
}

class AdminLiveChatInitial extends AdminLiveChatState {
  const AdminLiveChatInitial();
}

// Load the rooms

class AdminLiveChatLoadRoomsInProgress extends AdminLiveChatState {
  const AdminLiveChatLoadRoomsInProgress();
}

class AdminLiveChatLoadRoomsSuccess extends AdminLiveChatState {
  const AdminLiveChatLoadRoomsSuccess({required super.roomsState});
}

class AdminLiveChatLoadRoomsFailure extends AdminLiveChatState {
  const AdminLiveChatLoadRoomsFailure(this.exception);

  final LiveChatException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

class AdminLiveChatLoadMoreRoomsInProgress extends AdminLiveChatState {
  const AdminLiveChatLoadMoreRoomsInProgress({required super.roomsState});
}

// For room actions such as delete room etc...

class AdminLiveChatActionInProgress extends AdminLiveChatState {
  const AdminLiveChatActionInProgress({
    required super.roomsState,
    required this.roomId,
  });

  final String roomId;
}

class AdminLiveChatActionSuccess extends AdminLiveChatState {
  const AdminLiveChatActionSuccess({required super.roomsState});
}

class AdminLiveChatActionFailure extends AdminLiveChatState {
  const AdminLiveChatActionFailure(
    this.exception, {
    required super.roomsState,
  });

  final LiveChatException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}
