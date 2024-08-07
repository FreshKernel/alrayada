import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/localizations/app_localization_extension.dart';
import '../logic/user_cubit.dart';
import 'auth_form.dart';
import 'auth_verify_email.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const routeName = '/auth';

  Widget _getScreenByAuthState(
    UserState userState, {
    required BuildContext context,
  }) {
    final user = userState.userCredential?.user;
    if (user != null && !user.isEmailVerified) {
      return const AuthVerifyEmailScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.authentication),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: const FlutterLogo(
                size: 150,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Expanded(
              child: Card(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: AuthenticationForm(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 330),
          transitionBuilder: (child, animation) {
            // This animation is from flutter.dev example
            final tween = Tween(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).chain(
              CurveTween(curve: Curves.ease),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          child: _getScreenByAuthState(state, context: context),
        );
      },
    );
  }
}
