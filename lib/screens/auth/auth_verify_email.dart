import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../data/user/auth_exceptions.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/connection/connection_cubit.dart';
import '../../utils/extensions/scaffold_messenger.dart';
import '../../widgets/errors/w_internet_error.dart';

class AuthVerifyEmail extends StatefulWidget {
  const AuthVerifyEmail({super.key});

  @override
  State<AuthVerifyEmail> createState() => _AuthVerifyEmailState();
}

class _AuthVerifyEmailState extends State<AuthVerifyEmail> {
  var _isLoading = false;

  Future<void> _checkEmailVerification() async {
    final authBloc = context.read<AuthCubit>();
    setState(() => _isLoading = true);
    await context.read<AuthCubit>().fetchUser();
    setState(() => _isLoading = false);

    final userCredential = authBloc.state.userCredential;
    if (userCredential == null) return;
    if (!mounted) return;

    if (!userCredential.user.isEmailVerified) {
      ScaffoldMessenger.of(context).showSnackBarText(
        context.loc.emailIsStillNotVerified,
      );
      return;
    }
    context.pop();
  }

  Future<void> _sendEmailVerificationLink() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final localizations = context.loc;

    setState(() => _isLoading = true);
    await context.read<AuthCubit>().sendEmailVerificationLink();
    setState(() => _isLoading = false);

    scaffoldMessenger.showSnackBarText(
      localizations.authEmailVerificationLinkSent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.verifyYourEmail),
      ),
      body: BlocBuilder<ConnectionCubit, ConnState>(
        builder: (context, state) {
          if (state is ConnStateDisconnected) {
            return const InternetError(
              onTryAgain: null,
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Lottie.asset(Assets.lottie.auth.email.path),
                  Text(
                    context.loc.verifyYourEmail,
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  BlocConsumer<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final email = state.userCredential?.user.email ??
                          (throw StateError(
                              'To access the verify email screen, the user must be authenticated'));
                      return Text(
                        email,
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      );
                    },
                    listener: (context, state) {
                      final authException = state.exception;
                      if (authException != null) {
                        switch (authException) {
                          case EmailVerificationLinkAlreadySentAuthException():
                            ScaffoldMessenger.of(context).showSnackBarText(
                              context.loc
                                  .verificationLinkIsAlreadySentWithMinutesToExpire(
                                      authException.minutesToExpire.toString()),
                            );
                            break;
                          case EmailAlreadyVerifiedAuthException():
                            // TODO: If the email verified and the user
                            // click send email verification then let's handle that
                            break;
                          case UnknownAuthException():
                            ScaffoldMessenger.of(context).showSnackBarText(
                              context.loc
                                  .unknownErrorWithMsg(authException.message),
                            );
                            break;
                          default:
                            ScaffoldMessenger.of(context).showSnackBarText(
                              context.loc
                                  .unknownErrorWithMsg(authException.message),
                            );
                            break;
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.loc.verifyYourEmailDesc,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  if (!_isLoading) ...[
                    SizedBox(
                      width: double.infinity,
                      child: PlatformElevatedButton(
                        onPressed: _checkEmailVerification,
                        child: Text(context.loc.continueText),
                      ),
                    ),
                    PlatformTextButton(
                      onPressed: _sendEmailVerificationLink,
                      child: Text(context.loc.resendEmail),
                    ),
                  ] else
                    const CircularProgressIndicator.adaptive()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
