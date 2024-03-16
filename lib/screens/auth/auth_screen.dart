import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import 'auth_form.dart';
import 'auth_verify_email.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const routeName = '/authentication';

  Widget _getScreenByAuthState(AuthState authState,
      {required BuildContext context}) {
    final user = authState.userCredential?.user;
    if (user != null && !user.isEmailVerified) {
      return const AuthVerifyEmail();
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 330),
          transitionBuilder: (child, animation) {
            // This animation is from flutter.dev example
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(
              CurveTween(curve: curve),
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
