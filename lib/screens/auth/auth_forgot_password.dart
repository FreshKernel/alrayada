import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../data/user/auth_exceptions.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../utils/extensions/scaffold_messenger_ext.dart';
import '../../widgets/auth/email_text_field.dart';

class AuthForgotPasswordScreen extends StatefulWidget {
  const AuthForgotPasswordScreen({required this.initialEmailText, super.key});

  static const routeName = '/forgotPassword';

  final String initialEmailText;

  @override
  State<AuthForgotPasswordScreen> createState() =>
      _AuthForgotPasswordScreenState();
}

class _AuthForgotPasswordScreenState extends State<AuthForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    await context
        .read<AuthCubit>()
        .sendResetPasswordLink(email: _emailController.text);
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmailText;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthForgotPasswordFailure) {
          final authException = state.exception;
          switch (authException) {
            case EmailNotFoundAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authEmailNotFound,
              );
              break;
            case ResetPasswordLinkAlreadySentAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.verificationLinkIsAlreadySentWithMinutesToExpire(
                  authException.minutesToExpire.toString(),
                ),
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.unknownErrorWithMsg(authException.message),
              );
              break;
          }
          return;
        }
        if (state is AuthForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.authEmailVerificationLinkSent,
          );
          context.pop();
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.forgotPassword),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Lottie.asset(Assets.lottie.auth.forgotPassword.path),
                  Text(
                    context.loc.forgotPassword,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.loc.forgotPasswordDesc,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  EmailTextField(
                    controller: _emailController,
                    customError: null,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthForgotPasswordInProgress) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: PlatformElevatedButton(
                          onPressed: _onSubmit,
                          child: Text(context.loc.submit),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
