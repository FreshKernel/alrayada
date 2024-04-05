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

class AdminAuthLoadInProgress extends AdminAuthState {
  const AdminAuthLoadInProgress();
}

class AdminAuthLoadSuccess extends AdminAuthState {
  const AdminAuthLoadSuccess({required super.usersState});
}

class AdminAuthLoadFailure extends AdminAuthState {
  const AdminAuthLoadFailure({required this.exception});

  final AdminAuthException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}

class AdminAuthLoadMoreInProgress extends AdminAuthState {
  const AdminAuthLoadMoreInProgress({required super.usersState});
}

// For user actions such as delete user etc...

class AdminAuthActionInProgress extends AdminAuthState {
  const AdminAuthActionInProgress({required super.usersState});
}

class AdminAuthActionSuccess extends AdminAuthState {
  const AdminAuthActionSuccess({required super.usersState});
}

class AdminAuthActionFailure extends AdminAuthState {
  const AdminAuthActionFailure({
    required this.exception,
    required super.usersState,
  });

  final AdminAuthException exception;

  @override
  List<Object?> get props => [exception, ...super.props];
}
