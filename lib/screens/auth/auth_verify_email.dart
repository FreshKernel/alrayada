import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';

import '../../data/user/auth_exceptions.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/connection/connection_cubit.dart';
import '../../utils/extensions/scaffold_messenger_ext.dart';
import '../../widgets/errors/w_internet_error.dart';

class AuthVerifyEmailScreen extends StatelessWidget {
  const AuthVerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.verifyYourEmail),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
            tooltip: context.loc.logout,
          )
        ],
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
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final email = state.userCredential?.user.email ?? '';
                      return Text(
                        email,
                        style: Theme.of(context).textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  Text(
                    context.loc.verifyYourEmailDesc,
                    style: Theme.of(context).textTheme.labelMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFetchUserFailure) {
                        ScaffoldMessenger.of(context).showSnackBarText(
                          context.loc
                              .unknownErrorWithMsg(state.exception.message),
                        );
                        return;
                      }
                      if (state is AuthFetchUserSuccess) {
                        final userCredential = state.userCredential;
                        if (userCredential == null) {
                          throw StateError(
                            'The user credential should not be null in the verify email screen',
                          );
                        }
                        if (!userCredential.user.isEmailVerified) {
                          ScaffoldMessenger.of(context).showSnackBarText(
                            context.loc.emailIsStillNotVerified,
                          );
                          return;
                        }
                        context.pop();
                        return;
                      }
                      if (state is AuthResendEmailVerificationFailure) {
                        final authException = state.exception;
                        switch (authException) {
                          case UserNotLoggedInAnyMoreAuthException():
                            context.read<AuthCubit>().logout();
                            break;
                          case EmailVerificationLinkAlreadySentAuthException():
                            ScaffoldMessenger.of(context).showSnackBarText(
                              context.loc
                                  .verificationLinkIsAlreadySentWithMinutesToExpire(
                                authException.minutesToExpire.toString(),
                              ),
                            );
                            break;
                          case EmailAlreadyVerifiedAuthException():
                            context.read<AuthCubit>().fetchUser();
                            break;
                          case TooManyRequestsAuthException():
                            ScaffoldMessenger.of(context).showSnackBarText(
                                context.loc.tooManyRequestsPleaseTryAgainLater);
                            break;
                          default:
                            ScaffoldMessenger.of(context).showSnackBarText(
                              context.loc
                                  .unknownErrorWithMsg(authException.message),
                            );
                            break;
                        }
                        return;
                      }
                      if (state is AuthResendEmailVerificationSuccess) {
                        ScaffoldMessenger.of(context).showSnackBarText(
                          context.loc.authEmailVerificationLinkSent,
                        );
                        return;
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthFetchUserInProgress) {
                        return const CircularProgressIndicator.adaptive();
                      }
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: PlatformElevatedButton(
                              onPressed: () =>
                                  context.read<AuthCubit>().fetchUser(),
                              child: Text(context.loc.continueText),
                            ),
                          ),
                          PlatformTextButton(
                            onPressed: () => context
                                .read<AuthCubit>()
                                .sendEmailVerificationLink(),
                            child: Text(context.loc.resendEmail),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
