import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../common/extensions/scaffold_messenger_ext.dart';
import '../../../common/localizations/app_localization_extension.dart';
import '../../../common/presentation/widgets/errors/unknown_error.dart';
import '../../../common/presentation/widgets/scroll_edge_detector.dart';
import '../../user/logic/admin_user_cubit.dart';
import '../../user/presentation/admin_user_tile.dart';

class AdminUsersTab extends StatelessWidget {
  const AdminUsersTab({super.key});

  static const id = 'adminUsersTab';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            onSubmitted: (value) => context.read<AdminUserCubit>().searchUsers(
                  search: value,
                ),
            hintText: context.loc.search,
            leading: Icon(PlatformIcons(context).search),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 16),
            ),
            textInputAction: TextInputAction.search,
          ),
        ),
        const Expanded(
          child: _UsersList(),
        ),
      ],
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminUserCubit, AdminUserState>(
      listener: (context, state) {
        final status = state.status;
        if (status is AdminUserActionFailure) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.unknownErrorWithMsg(
              status.exception.toString(),
            ),
          );
        }
      },
      builder: (context, state) {
        final status = state.status;
        if (status is AdminUserLoadUsersInProgress) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (status is AdminUserLoadUsersFailure) {
          return UnknownError(
            onTryAgain: () => context.read<AdminUserCubit>().loadUsers(),
          );
        }
        final users = state.usersState.users;
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            await context.read<AdminUserCubit>().loadUsers();
          },
          child: ScrollEdgeDetector(
            onBottom: () => context.read<AdminUserCubit>().loadMoreUsers(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: status is AdminUserUsersLoadMoreInProgress
                  ? users.length + 1
                  : users.length,
              itemBuilder: (context, index) {
                if (index == users.length) {
                  // Loading indicator when loading more items
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                final user = users[index];
                return AdminUserTile(
                  user: user,
                  index: index,
                  isLoading: status is AdminUserActionInProgress &&
                      status.userId == user.id,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
