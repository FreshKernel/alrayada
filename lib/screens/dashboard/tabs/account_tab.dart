import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../constants.dart';
import '../../../data/user/models/user.dart';
import '../../../gen/assets.gen.dart';
import '../../../l10n/app_localizations.dart';
import '../../../logic/user/user_cubit.dart';
import '../../../utils/extensions/scaffold_messenger_ext.dart';
import '../../admin_dashboard/admin_dashboard_screen.dart';
import '../../auth/auth_screen.dart';
import '../../profile/profile_screen.dart';
import '../../settings/settings_screen.dart';
import '../tab_item.dart';
import 'orders/orders_tab.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({
    required this.navigateToTab,
    super.key,
  });

  static const id = 'accountTab';

  final TabItemOnNavigateToTabCallback navigateToTab;

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
  }

  Widget _buildAccountTile({
    required String title,
    required String subTitle,
    required IconData iconData,
    required VoidCallback? onTap,
    bool isAuthRequired = false,
  }) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    );
    final listTile = BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return ListTile(
          onTap: isAuthRequired
              ? (state.userCredential != null
                  ? onTap
                  : () => ScaffoldMessenger.of(context)
                      .showSnackBarText(context.loc.youNeedToLoginFirst))
              : onTap,
          title: Text(title),
          trailing: Icon(PlatformIcons(context).forward),
          leading: Icon(
            iconData,
            semanticLabel: title,
          ),
          subtitle: Text(subTitle),
          shape: shape,
        );
      },
    );
    return Semantics(
      label: title,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Card(
          shape: shape,
          child: listTile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await context.read<UserCubit>().fetchUser();
      },
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              final userCredential = state.userCredential;
              return Column(
                children: [
                  if (userCredential != null)
                    Stack(
                      children: [
                        (userCredential.user.pictureUrl == null)
                            ? const CircleAvatar(
                                radius: 47,
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 47,
                                backgroundImage: CachedNetworkImageProvider(
                                  userCredential.user.pictureUrl ??
                                      (throw StateError(
                                          'The iamge url should not be null')),
                                ),
                              ),
                        if (userCredential.user.isAccountActivated)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(
                              isCupertino(context)
                                  ? CupertinoIcons.checkmark_seal_fill
                                  : Icons.verified_sharp,
                              color: isMaterial(context) ? Colors.blue : null,
                            ),
                          ),
                      ],
                    )
                  else
                    Lottie.asset(
                      Assets.lottie.auth.login2.path,
                      width: 230,
                      alignment: Alignment.bottomCenter,
                    ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      if (userCredential != null) ...[
                        Text(
                          context.loc.welcomeAgainWithLabName(
                            userCredential.user.info.labOwnerName,
                          ),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 3)
                      ],
                      userCredential != null
                          ? Text(
                              context.loc.joinedInWithDate(
                                  DateFormat.yMMMMEEEEd()
                                      .format(userCredential.user.createdAt)),
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            )
                          : PlatformTextButton(
                              onPressed: () =>
                                  context.push(AuthScreen.routeName),
                              child: Text(context.loc.signIn),
                            ),
                      if (userCredential != null &&
                          !userCredential.user.isEmailVerified) ...[
                        const SizedBox(height: 12),
                        PlatformElevatedButton(
                          child: Text(context.loc.verifyYourEmail),
                          onPressed: () => context.push(AuthScreen.routeName),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildAccountTile(
                    title: context.loc.accountData,
                    subTitle: context.loc.updateAllOfYourData,
                    iconData: PlatformIcons(context).accountCircleSolid,
                    onTap: () => context.push(ProfileScreen.routeName),
                    isAuthRequired: true,
                  ),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      if (state.userCredential?.user.role != UserRole.admin) {
                        return const SizedBox.shrink();
                      }
                      return _buildAccountTile(
                        title: context.loc.adminDashboard,
                        subTitle: context.loc.manageEverythingInOnePlace,
                        iconData: isCupertino(context)
                            ? CupertinoIcons.square_grid_2x2_fill
                            : Icons.dashboard,
                        onTap: () =>
                            context.push(AdminDashboardScreen.routeName),
                      );
                    },
                  ),
                  _buildAccountTile(
                    title: context.loc.orders,
                    subTitle: context.loc.viewAllOfYourOrders,
                    iconData: PlatformIcons(context).shoppingCart,
                    onTap: () => widget.navigateToTab(OrdersTab.id),
                    isAuthRequired: true,
                  ),
                  _buildAccountTile(
                    title: context.loc.favorites,
                    subTitle: context.loc.viewAllOfYourWishlist,
                    iconData: PlatformIcons(context).favoriteOutline,
                    onTap: () =>
                        throw UnimplementedError(), // TODO: Implement the favorites screen
                  ),
                  _buildAccountTile(
                    title: context.loc.privacyPolicy,
                    subTitle: context.loc.openPrivacyPolicyPage,
                    iconData: PlatformIcons(context).padlockSolid,
                    onTap: () => launchUrlString(Constants.privacyPolicy),
                  ),
                  _buildAccountTile(
                    title: context.loc.socialMedia,
                    subTitle: context.loc.followUsOnSocialMedia,
                    iconData: PlatformIcons(context).share,
                    onTap: () =>
                        throw UnimplementedError(), // TODO: Implement the share button
                  ),
                  _buildAccountTile(
                    title: context.loc.settings,
                    subTitle: context.loc.selectYourPreferences,
                    iconData: PlatformIcons(context).settings,
                    onTap: () => context.push(SettingsScreen.routeName),
                  ),
                  const SizedBox(height: 6),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      if (state.userCredential == null) {
                        return const SizedBox.shrink(); // No logout button
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: double.infinity,
                          child: PlatformWidget(
                            cupertino: (context, platform) => CupertinoButton(
                              onPressed: () =>
                                  context.read<UserCubit>().logout(),
                              child: Text(context.loc.logout),
                            ),
                            material: (context, platform) => OutlinedButton(
                              onPressed: () =>
                                  context.read<UserCubit>().logout(),
                              child: Text(context.loc.logout),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
