import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../data/user/user_exceptions.dart';
import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/connectivity/connectivity_cubit.dart';
import '../../logic/user/user_cubit.dart';
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
            onPressed: () => context.read<UserCubit>().logout(),
            icon: const Icon(Icons.logout),
            tooltip: context.loc.logout,
          )
        ],
      ),
      body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          if (state is ConnectivityDisconnected) {
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
                  BlocBuilder<UserCubit, UserState>(
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
                  BlocConsumer<UserCubit, UserState>(
                    listener: (context, state) {
                      if (state is UserFetchUserFailure) {
                        ScaffoldMessenger.of(context).showSnackBarText(
                          context.loc
                              .unknownErrorWithMsg(state.exception.message),
                        );
                        return;
                      }
                      if (state is UserFetchUserSuccess) {
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
                      if (state is UserResendEmailVerificationFailure) {
                        final exception = state.exception;
                        switch (exception) {
                          case UserNotLoggedInAnyMoreUserException():
                            context.read<UserCubit>().logout();
                            break;
                          case EmailVerificationLinkAlreadySentUserException():
                            ScaffoldMessenger.of(context).showSnackBarText(
                              context.loc
                                  .verificationLinkIsAlreadySentWithMinutesToExpire(
                                exception.minutesToExpire.toString(),
                              ),
                            );
                            break;
                          case EmailAlreadyVerifiedUserException():
                            context.read<UserCubit>().fetchUser();
                            break;
                          case TooManyRequestsUserException():
                            ScaffoldMessenger.of(context).showSnackBarText(
                                context.loc.tooManyRequestsPleaseTryAgainLater);
                            break;
                          default:
                            ScaffoldMessenger.of(context).showSnackBarText(
                              context.loc
                                  .unknownErrorWithMsg(exception.message),
                            );
                            break;
                        }
                        return;
                      }
                      if (state is UserResendEmailVerificationSuccess) {
                        ScaffoldMessenger.of(context).showSnackBarText(
                          context.loc.authEmailVerificationLinkSent,
                        );
                        return;
                      }
                    },
                    builder: (context, state) {
                      if (state is UserFetchUserInProgress) {
                        return const CircularProgressIndicator.adaptive();
                      }
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: PlatformElevatedButton(
                              onPressed: () =>
                                  context.read<UserCubit>().fetchUser(),
                              child: Text(context.loc.continueText),
                            ),
                          ),
                          PlatformTextButton(
                            onPressed: () => context
                                .read<UserCubit>()
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
