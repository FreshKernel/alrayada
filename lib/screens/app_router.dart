import 'package:go_router/go_router.dart';

import 'account_data/account_data_screen.dart';
import 'auth/auth_forgot_password.dart';
import 'auth/auth_screen.dart';
import 'auth/auth_social_login_sign_up.dart';
import 'dashboard/dashboard_screen.dart';
import 'notifications/notifications_screen.dart';
import 'settings/settings_screen.dart';
import 'support/support_screen.dart';

class AppRouter {
  const AppRouter._();

  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: SupportScreen.routeName,
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: AccountDataScreen.routeName,
        builder: (context, state) => const AccountDataScreen(),
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
    ],
  );
}
