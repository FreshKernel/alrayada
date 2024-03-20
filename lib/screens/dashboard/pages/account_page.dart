import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../logic/auth/auth_cubit.dart';
import '../../auth/auth_screen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final userCredential = state.userCredential;
          if (userCredential != null) {
            if (!userCredential.user.isEmailVerified) {
              return PlatformElevatedButton(
                child: Text(context.loc.verifyYourEmail),
                onPressed: () => context.push(AuthScreen.routeName),
              );
            }
            return PlatformElevatedButton(
              child: Text(context.loc.logout),
              onPressed: () => context.read<AuthCubit>().logout(),
            );
          }
          return PlatformElevatedButton(
            child: Text(context.loc.signIn),
            onPressed: () => context.push(AuthScreen.routeName),
          );
        },
      ),
    );
  }
}
