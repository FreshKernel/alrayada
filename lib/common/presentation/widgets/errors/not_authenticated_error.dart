import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../auth/presentation/auth_screen.dart';
import '../../../gen/assets.gen.dart';
import '../../../localizations/app_localization_extension.dart';

// TODO: I might remove this completely
class NotAuthenticatedError extends StatelessWidget {
  const NotAuthenticatedError({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              Assets.lottie.auth.login.path,
            ),
            const SizedBox(height: 20),
            PlatformElevatedButton(
              onPressed: () => context.push(AuthScreen.routeName),
              child: Text(context.loc.signIn),
            )
          ],
        ),
      ),
    );
  }
}
