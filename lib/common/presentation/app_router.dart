import 'package:go_router/go_router.dart';

import '../../admin/dashboard/admin_dashboard_screen.dart';
import '../../admin/dashboard/tabs/product_hub/categories/admin_category_details_screen.dart';
import '../../auth/presentation/auth_forgot_password.dart';
import '../../auth/presentation/auth_screen.dart';
import '../../auth/presentation/auth_social_login_sign_up.dart';
import '../../dashboard/dashboard_screen.dart';
import '../../live_chat/presentation/live_chat_screen.dart';
import '../../notifications/notifications_screen.dart';
import '../../products/data/category/product_category.dart';
import '../../products/presentation/category_details_screen.dart';
import '../../profile/profile_screen.dart';
import '../../settings/presentation/settings_screen.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: LiveChatScreen.routeName,
        builder: (context, state) => LiveChatScreen(
          args: state.extra as LiveChatScreenArgs,
        ),
      ),
      GoRoute(
        path: ProfileScreen.routeName,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: NotificationsScreen.routeName,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: SettingsScreen.routeName,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AuthScreen.routeName,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: AuthForgotPasswordScreen.routeName,
        builder: (context, state) => AuthForgotPasswordScreen(
          initialEmailText: state.extra as String,
        ),
      ),
      GoRoute(
        path: AuthSocialLoginSignUpScreen.routeName,
        builder: (context, state) => AuthSocialLoginSignUpScreen(
          args: state.extra as AuthSocialLoginSignUpScreenArgs,
        ),
      ),
      GoRoute(
        path: CategoryDetailsScreen.routeName,
        builder: (context, state) => CategoryDetailsScreen(
          category: state.extra as ProductCategory,
        ),
      ),
      ..._adminRoutes,
    ],
  );

  static final _adminRoutes = <GoRoute>[
    GoRoute(
      path: AdminDashboardScreen.routeName,
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: AdminCategoryDetailsScreen.routeName,
      builder: (context, state) => AdminCategoryDetailsScreen(
        category: state.extra as ProductCategory,
      ),
    ),
  ];
}
