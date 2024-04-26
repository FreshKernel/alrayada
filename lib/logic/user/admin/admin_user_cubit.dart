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
  }) : super(const AdminUserInitial()) {
    loadUsers();
  }

  final AdminUserApi adminUserApi;

  static const _limit = 10;

  Future<void> loadUsers() async {
    try {
      emit(const AdminUserLoadUsersInProgress());
      final users = await adminUserApi.getAllUsers(
        searchQuery: '',
        page: 1,
        limit: _limit,
      );
      emit(AdminUserLoadUsersSuccess(
        usersState: AdminUserUsersState(
          users: users,
          hasReachedLastPage: users.isEmpty,
        ),
      ));
    } on AdminUserException catch (e) {
      emit(AdminUserLoadUsersFailure(e));
    }
  }

  Future<void> loadMoreUsers() async {
    if (state.usersState.hasReachedLastPage) {
      return;
    }
    if (state is AdminUserLoadMoreUsersInProgress) {
      // In case if the function called more than once
      return;
    }
    try {
      emit(AdminUserLoadMoreUsersInProgress(
        usersState: state.usersState.copyWith(
          page: state.usersState.page + 1,
        ),
      ));
      final moreUsers = await adminUserApi.getAllUsers(
        searchQuery: state.usersState.searchQuery,
        page: state.usersState.page,
        limit: _limit,
      );
      emit(AdminUserLoadUsersSuccess(
        usersState: state.usersState.copyWith(
          users: [
            ...state.usersState.users,
            ...moreUsers,
          ],
          hasReachedLastPage: moreUsers.isEmpty,
        ),
      ));
    } on AdminUserException catch (e) {
      emit(AdminUserLoadUsersFailure(e));
    }
  }

  Future<void> searchAllUsers({required String searchQuery}) async {
    try {
      emit(const AdminUserLoadUsersInProgress());
      final users = await adminUserApi.getAllUsers(
        searchQuery: searchQuery,
        page: 1,
        limit: _limit,
      );
      emit(AdminUserLoadUsersSuccess(
          usersState: AdminUserUsersState(
        users: users,
        searchQuery: searchQuery, // So pagination work when searching
      )));
    } on AdminUserException catch (e) {
      emit(AdminUserLoadUsersFailure(e));
    }
  }

  Future<void> setAccountActivated({
    required String userId,
    required bool value,
  }) async {
    try {
      emit(AdminUserActionInProgress(
        userId: userId,
        usersState: state.usersState,
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
      emit(AdminUserActionSuccess(
        usersState: state.usersState.copyWith(
          users: users,
        ),
      ));
    } on AdminUserException catch (e) {
      emit(AdminUserActionFailure(
        e,
        usersState: state.usersState,
      ));
    }
  }

  Future<void> deleteUserAccount({
    required String userId,
  }) async {
    try {
      emit(AdminUserActionInProgress(
        userId: userId,
        usersState: state.usersState,
      ));
      await adminUserApi.deleteUserAccount(
        userId: userId,
      );
      final users = [...state.usersState.users]..removeWhere(
          (user) => user.id == userId,
        );
      emit(AdminUserActionSuccess(
          usersState: state.usersState.copyWith(
        users: users,
      )));
    } on AdminUserException catch (e) {
      emit(AdminUserActionFailure(
        e,
        usersState: state.usersState,
      ));
    }
  }

  Future<void> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      emit(AdminUserActionInProgress(
        userId: userId,
        usersState: state.usersState,
      ));
      await adminUserApi.sendNotificationToUser(
        userId: userId,
        title: title,
        body: body,
      );
      emit(AdminUserActionSuccess(usersState: state.usersState));
    } on AdminUserException catch (e) {
      emit(AdminUserActionFailure(
        e,
        usersState: state.usersState,
      ));
    }
  }
}
