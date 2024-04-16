part of 'admin_auth_cubit.dart';

class AdminAuthUsersState extends Equatable {
  const AdminAuthUsersState({
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

  AdminAuthUsersState copyWith({
    List<User>? users,
    int? page,
    bool? hasReachedLastPage,
    String? searchQuery,
  }) {
    return AdminAuthUsersState(
      users: users ?? this.users,
      page: page ?? this.page,
      hasReachedLastPage: hasReachedLastPage ?? this.hasReachedLastPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

@immutable
sealed class AdminAuthState extends Equatable {
  const AdminAuthState({
    this.usersState = const AdminAuthUsersState(),
  });

  final AdminAuthUsersState usersState;
  @override
  List<Object?> get props => [
        usersState,
      ];
}

class AdminAuthInitial extends AdminAuthState {
  const AdminAuthInitial();
}

// For loading the users

class AdminAuthLoadUsersInProgress extends AdminAuthState {
  const AdminAuthLoadUsersInProgress();
}

class AdminAuthLoadUsersSuccess extends AdminAuthState {
  const AdminAuthLoadUsersSuccess({required super.usersState});
}

class AdminAuthLoadUsersFailure extends AdminAuthState {
  const AdminAuthLoadUsersFailure(this.exception);

  final AdminAuthException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

class AdminAuthLoadMoreUsersInProgress extends AdminAuthState {
  const AdminAuthLoadMoreUsersInProgress({required super.usersState});
}

// For user actions such as delete user etc...

class AdminAuthActionInProgress extends AdminAuthState {
  const AdminAuthActionInProgress({
    required super.usersState,
    required this.userId,
  });

  /// The user id for that each tile
  final String userId;
}

class AdminAuthActionSuccess extends AdminAuthState {
  const AdminAuthActionSuccess({required super.usersState});
}

class AdminAuthActionFailure extends AdminAuthState {
  const AdminAuthActionFailure(
    this.exception, {
    required super.usersState,
  });

  final AdminAuthException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}
