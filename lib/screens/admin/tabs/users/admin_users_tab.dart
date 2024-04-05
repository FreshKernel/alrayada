import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../logic/auth/admin/admin_auth_cubit.dart';
import '../../../../utils/extensions/scaffold_messenger_ext.dart';
import '../../../../widgets/errors/w_error.dart';
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
                context.read<AdminAuthCubit>().searchAllUsers(
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
    return BlocConsumer<AdminAuthCubit, AdminAuthState>(
      listener: (context, state) {
        if (state is AdminAuthActionFailure) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.unknownErrorWithMsg(state.exception.toString()),
          );
        }
      },
      builder: (context, state) {
        if (state is AdminAuthLoadInProgress) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is AdminAuthLoadFailure) {
          return ErrorWithTryAgain(
            onTryAgain: () => context.read<AdminAuthCubit>().initLoadUsers(),
          );
        }
        final users = state.usersState.users;
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            await context.read<AdminAuthCubit>().initLoadUsers();
          },
          child: ScrollEdgeDetector(
            onBottom: () => context.read<AdminAuthCubit>().loadMoreUsers(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: state is AdminAuthLoadMoreInProgress
                  ? users.length + 1
                  : users.length,
              itemBuilder: (context, index) {
                if (index == state.usersState.users.length) {
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
