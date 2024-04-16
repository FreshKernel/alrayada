import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../data/user/admin/admin_auth_exceptions.dart';
import '../../../data/user/admin/admin_auth_repository.dart';
import '../../../data/user/models/user.dart';

part 'admin_auth_state.dart';

class AdminAuthCubit extends Cubit<AdminAuthState> {
  AdminAuthCubit({
    required this.adminAuthRepository,
  }) : super(const AdminAuthInitial()) {
    initLoadUsers();
  }

  final AdminAuthRepository adminAuthRepository;

  static const _limit = 10;

  Future<void> initLoadUsers() async {
    try {
      emit(const AdminAuthLoadUsersInProgress());
      final users = await adminAuthRepository.getAllUsers(
        searchQuery: '',
        page: 1,
        limit: _limit,
      );
      emit(AdminAuthLoadUsersSuccess(
        usersState: AdminAuthUsersState(
          users: users,
          page: 1,
        ),
      ));
    } on AdminAuthException catch (e) {
      emit(AdminAuthLoadUsersFailure(e));
    }
  }

  Future<void> loadMoreUsers() async {
    if (state.usersState.hasReachedLastPage) {
      return;
    }
    if (state is AdminAuthLoadMoreUsersInProgress) {
      // In case if the function called more than once
      return;
    }
    try {
      emit(AdminAuthLoadMoreUsersInProgress(
        usersState: state.usersState.copyWith(
          page: state.usersState.page + 1,
        ),
      ));
      final moreUsers = await adminAuthRepository.getAllUsers(
        searchQuery: state.usersState.searchQuery,
        page: state.usersState.page,
        limit: _limit,
      );
      emit(AdminAuthLoadUsersSuccess(
        usersState: state.usersState.copyWith(
          users: [
            ...state.usersState.users,
            ...moreUsers,
          ],
          hasReachedLastPage: moreUsers.isEmpty,
        ),
      ));
    } on AdminAuthException catch (e) {
      emit(AdminAuthLoadUsersFailure(e));
    }
  }

  Future<void> searchAllUsers({required String searchQuery}) async {
    try {
      emit(const AdminAuthLoadUsersInProgress());
      final users = await adminAuthRepository.getAllUsers(
        searchQuery: searchQuery,
        page: 1,
        limit: _limit,
      );
      emit(AdminAuthLoadUsersSuccess(
          usersState: AdminAuthUsersState(
        users: users,
        searchQuery: searchQuery, // So pagination work when searching
      )));
    } on AdminAuthException catch (e) {
      emit(AdminAuthLoadUsersFailure(e));
    }
  }

  Future<void> setAccountActivated({
    required String userId,
    required bool value,
  }) async {
    try {
      emit(AdminAuthActionInProgress(
        userId: userId,
        usersState: state.usersState,
      ));
      await adminAuthRepository.setAccountActivated(
        userId: userId,
        value: value,
      );
      final users = state.usersState.users.map((user) {
        if (user.userId == userId) {
          return user.copyWith(isAccountActivated: value);
        }
        return user;
      }).toList();
      emit(AdminAuthActionSuccess(
        usersState: state.usersState.copyWith(
          users: users,
        ),
      ));
    } on AdminAuthException catch (e) {
      emit(AdminAuthActionFailure(
        e,
        usersState: state.usersState,
      ));
    }
  }

  Future<void> deleteUserAccount({
    required String userId,
  }) async {
    try {
      emit(AdminAuthActionInProgress(
        userId: userId,
        usersState: state.usersState,
      ));
      await adminAuthRepository.deleteUserAccount(
        userId: userId,
      );
      final users = [...state.usersState.users]..removeWhere(
          (user) => user.userId == userId,
        );
      emit(AdminAuthActionSuccess(
          usersState: state.usersState.copyWith(
        users: users,
      )));
    } on AdminAuthException catch (e) {
      emit(AdminAuthActionFailure(
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
      emit(AdminAuthActionInProgress(
        userId: userId,
        usersState: state.usersState,
      ));
      await adminAuthRepository.sendNotificationToUser(
        userId: userId,
        title: title,
        body: body,
      );
      emit(AdminAuthActionSuccess(usersState: state.usersState));
    } on AdminAuthException catch (e) {
      emit(AdminAuthActionFailure(
        e,
        usersState: state.usersState,
      ));
    }
  }
}
