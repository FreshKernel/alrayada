import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/extensions/scaffold_messenger.dart';
import '../../widgets/auth/email_text_field.dart';

class AuthForgotPassword extends StatefulWidget {
  const AuthForgotPassword({super.key});

  static const routeName = '/forgotPassword';

  @override
  State<AuthForgotPassword> createState() => _AuthForgotPasswordState();
}

class _AuthForgotPasswordState extends State<AuthForgotPassword> {
  final _formKey = GlobalKey<FormState>();

  void _onSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  controller: TextEditingController(),
                  customError: null,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                SizedBox(
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
    );
  }
}
