import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../logic/user/admin/admin_user_cubit.dart';
import '../../../../utils/extensions/scaffold_messenger_ext.dart';
import '../../../../widgets/errors/unknown_error.dart';
import '../../../../widgets/scroll_edge_detector.dart';
import 'admin_user_tile.dart';

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
            onSubmitted: (value) =>
                context.read<AdminUserCubit>().searchAllUsers(
                      searchQuery: value,
                    ),
            hintText: context.loc.search,
            leading: Icon(PlatformIcons(context).search),
            padding: MaterialStateProperty.all(
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
        if (state is AdminUserActionFailure) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.unknownErrorWithMsg(state.exception.toString()),
          );
        }
      },
      builder: (context, state) {
        if (state is AdminUserLoadUsersInProgress) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is AdminUserLoadUsersFailure) {
          return UnknownError(
            onTryAgain: () => context.read<AdminUserCubit>().initLoadUsers(),
          );
        }
        final users = state.usersState.users;
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            await context.read<AdminUserCubit>().initLoadUsers();
          },
          child: ScrollEdgeDetector(
            onBottom: () => context.read<AdminUserCubit>().loadMoreUsers(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: state is AdminUserLoadMoreUsersInProgress
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
                );
              },
            ),
          ),
        );
      },
    );
  }
}
