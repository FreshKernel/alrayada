import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/connection/connection_cubit.dart';
import '../../widgets/errors/w_internet_error.dart';
import 'auth_form_inputs.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({super.key});

  @override
  State<AuthenticationForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthenticationForm> {
  var _isLogin = true;
  final _appChannel = const MethodChannel('App');

  @override
  void initState() {
    super.initState();
    if (!kDebugMode && !kIsWeb && Platform.isAndroid) {
      _secureScreen(true);
    }
  }

  void _secureScreen(bool private) =>
      _appChannel.invokeMethod('setWindowPrivate', private);

  @override
  void dispose() {
    super.dispose();
    if (!kDebugMode && !kIsWeb && Platform.isAndroid) {
      _secureScreen(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final materialTheme = Theme.of(context);
    final cupertinoTheme = CupertinoTheme.of(context);
    return BlocBuilder<ConnectionCubit, ConnState>(
      builder: (context, state) {
        if (state is ConnStateDisconnected) {
          return const InternetError(
            onTryAgain: null,
          );
        }
        return Column(
          children: [
            const SizedBox(height: 14),
            Semantics(
              label: _isLogin
                  ? context.loc.welcomeAgain
                  : context.loc.registerAccount,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  _isLogin
                      ? context.loc.welcomeAgain
                      : context.loc.registerAccount,
                  textAlign: TextAlign.center,
                  style: (isCupertino(context)
                          ? cupertinoTheme.textTheme.navLargeTitleTextStyle
                          : materialTheme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontStyle: FontStyle.values.first))
                      ?.copyWith(fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Semantics(
              label: context.loc.enterTheAccountCredentialsToContinue,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  context.loc.enterTheAccountCredentialsToContinue,
                  textAlign: TextAlign.center,
                  style: (isCupertino(context)
                          ? cupertinoTheme.textTheme.navTitleTextStyle
                              .copyWith(color: Colors.grey)
                          : materialTheme.textTheme.bodySmall)
                      ?.copyWith(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            AuthFormInputs(
              onToggleIsLogin: () => setState(() {
                _isLogin = !_isLogin;
              }),
            ),
          ],
        );
      },
    );
  }
}
