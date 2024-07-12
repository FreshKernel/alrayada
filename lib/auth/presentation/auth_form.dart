import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/localizations/app_localization_extension.dart';
import '../../common/logic/connectivity/connectivity_cubit.dart';
import '../../common/presentation/widgets/errors/internet_error.dart';
import 'auth_form_inputs.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({super.key});

  @override
  State<AuthenticationForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthenticationForm> {
  /// Must be the same value in isLogin of [AuthFormInputs]
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
    return BlocBuilder<ConnectivityCubit, ConnectivityState>(
      builder: (context, state) {
        if (state is ConnectivityDisconnected) {
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
                  style: Theme.of(context).textTheme.headlineMedium,
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
                  style: Theme.of(context).textTheme.bodyMedium,
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
