import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/user/admin/admin_user_api.dart';
import '../../../data/user/admin/admin_user_exceptions.dart';
import '../../../data/user/models/user.dart';

part 'admin_user_state.dart';

class AdminUserCubit extends Cubit<AdminUserState> {
  AdminUserCubit({
    required this.adminUserApi,
  }) : super(const AdminUserState()) {
    loadUsers();
  }

  final AdminUserApi adminUserApi;

  static const _limit = 10;

  Future<void> loadUsers() async {
    try {
      emit(const AdminUserState(status: AdminUserLoadUsersInProgress()));
      final users = await adminUserApi.getAllUsers(
        page: 1,
        limit: _limit,
        search: '',
      );
      emit(AdminUserState(
        status: const AdminUserLoadUsersSuccess(),
        usersState: AdminUserUsersState(
          users: users,
          hasReachedLastPage: users.isEmpty,
        ),
      ));
    } on AdminUserException catch (e) {
      emit(AdminUserState(
        status: AdminUserLoadUsersFailure(e),
      ));
    }
  }

  Future<void> loadMoreUsers() async {
    if (state.usersState.hasReachedLastPage) {
      return;
    }
    if (state is AdminUserUsersLoadMoreInProgress) {
      // In case if the function called more than once
      return;
    }
    try {
      emit(state.copyWith(
        status: const AdminUserUsersLoadMoreInProgress(),
        usersState: state.usersState.copyWith(
          page: state.usersState.page + 1,
        ),
      ));
      final moreUsers = await adminUserApi.getAllUsers(
        search: state.usersState.search,
        page: state.usersState.page,
        limit: _limit,
      );
      emit(state.copyWith(
        status: const AdminUserLoadUsersSuccess(),
        usersState: state.usersState.copyWith(
          users: [
            ...state.usersState.users,
            ...moreUsers,
          ],
          hasReachedLastPage: moreUsers.isEmpty,
        ),
      ));
    } on AdminUserException catch (e) {
      emit(state.copyWith(
        status: AdminUserLoadUsersFailure(e),
      ));
    }
  }

  Future<void> searchUsers({required String search}) async {
    try {
      emit(state.copyWith(
        status: const AdminUserLoadUsersInProgress(),
        usersState: AdminUserUsersState(
          search: search,
        ),
      ));
      final users = await adminUserApi.getAllUsers(
        search: state.usersState.search,
        page: state.usersState.page,
        limit: _limit,
      );
      emit(state.copyWith(
        status: const AdminUserLoadUsersSuccess(),
        usersState: state.usersState.copyWith(
          users: users,
        ),
      ));
    } on AdminUserException catch (e) {
      emit(state.copyWith(
        status: AdminUserLoadUsersFailure(e),
      ));
    }
  }

  Future<void> setAccountActivated({
    required String userId,
    required bool value,
  }) async {
    try {
      emit(state.copyWith(
        status: AdminUserActionInProgress(userId: userId),
      ));
      await adminUserApi.setAccountActivated(
        userId: userId,
        value: value,
      );
      final users = state.usersState.users.map((user) {
        if (user.id == userId) {
          return user.copyWith(isAccountActivated: value);
        }
        return user;
      }).toList();
      emit(state.copyWith(
        status: const AdminUserActionSuccess(),
        usersState: state.usersState.copyWith(
          users: users,
        ),
      ));
    } on AdminUserException catch (e) {
      emit(state.copyWith(
        status: AdminUserActionFailure(e),
      ));
    }
  }

  Future<void> deleteUserAccount({
    required String userId,
  }) async {
    try {
      emit(state.copyWith(
        status: AdminUserActionInProgress(userId: userId),
      ));
      await adminUserApi.deleteUserAccount(
        userId: userId,
      );
      final users = [...state.usersState.users]..removeWhere(
          (user) => user.id == userId,
        );
      emit(state.copyWith(
        status: const AdminUserActionSuccess(),
        usersState: state.usersState.copyWith(
          users: users,
        ),
      ));
    } on AdminUserException catch (e) {
      emit(state.copyWith(
        status: AdminUserActionFailure(e),
      ));
    }
  }

  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      emit(state.copyWith(
        status: AdminUserActionInProgress(userId: userId),
      ));
      await adminUserApi.sendNotificationToUser(
        userId: userId,
        title: title,
        body: body,
      );
      emit(state.copyWith(
        status: const AdminUserActionSuccess(),
      ));
    } on AdminUserException catch (e) {
      emit(state.copyWith(
        status: AdminUserActionFailure(e),
      ));
    }
  }
}
