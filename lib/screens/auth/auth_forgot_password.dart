import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../data/user/user_exceptions.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/user/user_cubit.dart';
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

  String? _emailError;

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    await context
        .read<UserCubit>()
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
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserForgotPasswordFailure) {
          final exception = state.exception;
          switch (exception) {
            case EmailNotFoundUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authEmailNotFound,
              );
              setState(() => _emailError = context.loc.authEmailNotFound);
              break;
            case ResetPasswordLinkAlreadySentUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.verificationLinkIsAlreadySentWithMinutesToExpire(
                  exception.minutesToExpire.toString(),
                ),
              );
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.unknownErrorWithMsg(exception.message),
              );
              break;
          }
          return;
        }
        if (state is UserForgotPasswordSuccess) {
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
                    customError: _emailError,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      if (state is UserForgotPasswordInProgress) {
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
