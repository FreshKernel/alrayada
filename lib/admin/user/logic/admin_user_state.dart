part of 'admin_user_cubit.dart';

// TODO: Might rename this and similar classes to AdminUserSharedState, or we could
//   move all properties of AdminUserUsersState directly to AdminUserState.
//   We're mixing the subclass and single class approachs suggested by bloc library
//   only for this example, we might change the others or only change this instead
//   to ensure consistency.

@immutable
class AdminUserUsersState extends Equatable {
  const AdminUserUsersState({
    this.users = const [],
    this.page = 1,
    this.hasReachedLastPage = false,
    this.search = '',
  });

  final List<User> users;
  final int page;
  final bool hasReachedLastPage;
  final String search;

  @override
  List<Object?> get props => [
        users,
        page,
        hasReachedLastPage,
        search,
      ];

  AdminUserUsersState copyWith({
    List<User>? users,
    int? page,
    bool? hasReachedLastPage,
    String? search,
  }) {
    return AdminUserUsersState(
      users: users ?? this.users,
      page: page ?? this.page,
      hasReachedLastPage: hasReachedLastPage ?? this.hasReachedLastPage,
      search: search ?? this.search,
    );
  }
}

@immutable
class AdminUserState extends Equatable {
  const AdminUserState({
    this.usersState = const AdminUserUsersState(),
    this.status = const AdminUserInitial(),
  });

  final AdminUserUsersState usersState;
  // TODO: We might rename `status` to something else, see the first todo in this file
  final AdminUserStatus status;
  @override
  List<Object?> get props => [
        usersState,
        status,
      ];

  AdminUserState copyWith({
    AdminUserUsersState? usersState,
    AdminUserStatus? status,
  }) {
    return AdminUserState(
      usersState: usersState ?? this.usersState,
      status: status ?? this.status,
    );
  }
}

@immutable
sealed class AdminUserStatus extends Equatable {
  const AdminUserStatus();

  @override
  List<Object?> get props => [];
}

class AdminUserInitial extends AdminUserStatus {
  const AdminUserInitial();
}

// For loading the users

class AdminUserLoadUsersInProgress extends AdminUserStatus {
  const AdminUserLoadUsersInProgress();
}

class AdminUserLoadUsersSuccess extends AdminUserStatus {
  const AdminUserLoadUsersSuccess();
}

class AdminUserLoadUsersFailure extends AdminUserStatus {
  const AdminUserLoadUsersFailure(this.exception);

  final AdminUserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

class AdminUserUsersLoadMoreInProgress extends AdminUserStatus {
  const AdminUserUsersLoadMoreInProgress();
}

// For user actions such as delete user etc...

class AdminUserActionInProgress extends AdminUserStatus {
  const AdminUserActionInProgress({
    required this.userId,
  });

  /// The user id for that tile
  final String userId;

  @override
  List<Object?> get props => [userId, ...super.props];
}

class AdminUserActionSuccess extends AdminUserStatus {
  const AdminUserActionSuccess();
}

class AdminUserActionFailure extends AdminUserStatus {
  const AdminUserActionFailure(
    this.exception,
  );

  final AdminUserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}
