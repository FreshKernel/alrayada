import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../data/user/auth_exceptions.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../utils/extensions/scaffold_messenger.dart';
import '../../widgets/auth/email_text_field.dart';

class AuthForgotPassword extends StatefulWidget {
  const AuthForgotPassword({required this.initialEmailText, super.key});

  static const routeName = '/forgotPassword';

  final String initialEmailText;

  @override
  State<AuthForgotPassword> createState() => _AuthForgotPasswordState();
}

class _AuthForgotPasswordState extends State<AuthForgotPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    final authBloc = context.read<AuthCubit>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    setState(() => _isLoading = true);
    await authBloc.sendResetPasswordLink(email: _emailController.text);
    setState(() => _isLoading = false);

    if (!mounted) return;
    scaffoldMessenger.showSnackBarText(
      context.loc.authEmailVerificationLinkSent,
    );
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
        final authException = state.exception;
        if (authException == null) return;
        switch (authException) {
          case UserNotFoundAuthException():
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
          case UnknownAuthException():
            ScaffoldMessenger.of(context).showSnackBarText(
              context.loc.unknownErrorWithMsg(authException.message),
            );
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBarText(
              context.loc.unknownErrorWithMsg(authException.message),
            );
            break;
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
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : SizedBox(
                          width: double.infinity,
                          child: PlatformElevatedButton(
                            onPressed: _onSubmit,
                            child: Text(context.loc.submit),
                          ),
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
