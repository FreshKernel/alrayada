part of 'admin_user_cubit.dart';

class AdminUserUsersState extends Equatable {
  const AdminUserUsersState({
    this.users = const [],
    this.page = 1,
    this.hasReachedLastPage = false,
    this.searchQuery = '',
  });

  final List<User> users;
  final int page;
  final bool hasReachedLastPage;
  final String searchQuery;

  @override
  List<Object?> get props => [
        users,
        page,
        hasReachedLastPage,
        searchQuery,
      ];

  AdminUserUsersState copyWith({
    List<User>? users,
    int? page,
    bool? hasReachedLastPage,
    String? searchQuery,
  }) {
    return AdminUserUsersState(
      users: users ?? this.users,
      page: page ?? this.page,
      hasReachedLastPage: hasReachedLastPage ?? this.hasReachedLastPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

@immutable
sealed class AdminUserState extends Equatable {
  const AdminUserState({
    this.usersState = const AdminUserUsersState(),
  });

  final AdminUserUsersState usersState;
  @override
  List<Object?> get props => [
        usersState,
      ];
}

class AdminUserInitial extends AdminUserState {
  const AdminUserInitial();
}

// For loading the users

class AdminUserLoadUsersInProgress extends AdminUserState {
  const AdminUserLoadUsersInProgress();
}

class AdminUserLoadUsersSuccess extends AdminUserState {
  const AdminUserLoadUsersSuccess({required super.usersState});
}

class AdminUserLoadUsersFailure extends AdminUserState {
  const AdminUserLoadUsersFailure(this.exception);

  final AdminUserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

class AdminUserLoadMoreUsersInProgress extends AdminUserState {
  const AdminUserLoadMoreUsersInProgress({required super.usersState});
}

// For user actions such as delete user etc...

class AdminUserActionInProgress extends AdminUserState {
  const AdminUserActionInProgress({
    required super.usersState,
    required this.userId,
  });

  /// The user id for that each tile
  final String userId;
}

class AdminUserActionSuccess extends AdminUserState {
  const AdminUserActionSuccess({required super.usersState});
}

class AdminUserActionFailure extends AdminUserState {
  const AdminUserActionFailure(
    this.exception, {
    required super.usersState,
  });

  final AdminUserException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}
