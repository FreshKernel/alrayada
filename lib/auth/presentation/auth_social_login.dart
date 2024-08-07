import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../common/extensions/scaffold_messenger_ext.dart';
import '../../common/gen/assets.gen.dart';
import '../../common/localizations/app_localization_extension.dart';
import '../data/user_exceptions.dart';
import '../logic/user_cubit.dart';
import 'auth_social_login_sign_up.dart';

class AuthSocialLogin extends StatelessWidget {
  const AuthSocialLogin({super.key});

  Widget _buildButton({
    required String label,
    required Widget icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color fontColor,
  }) =>
      SizedBox(
        width: double.infinity,
        child: PlatformElevatedButton(
          color: backgroundColor,
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(color: fontColor),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Text(
                context.loc.orSignInUsingSocialMediaAccount,
                textAlign: TextAlign.center,
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 4),
        BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state is UserSocialLoginFailure) {
              final exception = state.exception;
              switch (exception) {
                case InvalidSocialInfoUserException():
                  ScaffoldMessenger.of(context).showSnackBarText(
                    exception.message,
                  );
                  break;
                case SocialEmailIsNotVerifiedUserException():
                  ScaffoldMessenger.of(context).showSnackBarText(
                    context.loc.emailIsStillNotVerified,
                  );
                  break;
                case SocialMissingSignUpDataUserException():
                  // I wanted the display name from social login provider
                  // will be as initial text when requesting user data
                  // but I didn't want to make the code messy so we will store
                  // in LocalStorage when calling social login and access it here
                  SharedPreferences.getInstance().then(
                    (value) => context.push(
                      AuthSocialLoginSignUpScreen.routeName,
                      extra: AuthSocialLoginSignUpScreenArgs(
                        initialLabOwnerNameText: value.getString(
                                UserCubit.socialLoginDisplayNamePrefKey) ??
                            '',
                        socialLogin: exception.socialLogin,
                      ),
                    ),
                  );
                  break;
                case TooManyRequestsUserException():
                  ScaffoldMessenger.of(context).showSnackBarText(
                    context.loc.tooManyRequestsPleaseTryAgainLater,
                  );
                  break;
                default:
                  ScaffoldMessenger.of(context).showSnackBarText(
                    context.loc.unknownErrorWithMsg(state.exception.message),
                  );
                  break;
              }
            }
            if (state is UserSocialLoginSuccess) {
              final userCredential = state.userCredential;
              if (userCredential == null) {
                throw StateError(
                  'The user credential should not be null in the success state',
                );
              }
              // The Auth screen will handle switching to the Verify Email screen
              // We want to pop only when the email is verified
              if (userCredential.user.isEmailVerified) {
                context.pop();
              }
              return;
            }
          },
          builder: (context, state) {
            if (state is UserSocialLoginInProgress) {
              return const CircularProgressIndicator.adaptive();
            }
            return Column(
              children: [
                _buildButton(
                  label: context.loc.loginWithGoogle,
                  icon: SvgPicture.asset(
                    Assets.svg.icons.google.path,
                    height: 25,
                    width: 25,
                  ),
                  onPressed: () => context.read<UserCubit>().loginWithGoogle(),
                  backgroundColor: Colors.white,
                  fontColor: Colors.black,
                ),
                const SizedBox(height: 8),
                _buildButton(
                  label: context.loc.loginWithApple,
                  icon: Icon(
                    Icons.apple,
                    semanticLabel: context.loc.loginWithApple,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () async {
                    final userBloc = context.read<UserCubit>();
                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                    final localizations = context.loc;

                    final isAvaliable = await SignInWithApple.isAvailable();
                    if (!isAvaliable) {
                      scaffoldMessenger.showSnackBarText(
                        localizations.signInWithAppleIsNotSupportedOnYourDevice,
                      );
                      return;
                    }
                    userBloc.loginWithApple();
                  },
                  backgroundColor: Colors.black,
                  fontColor: Colors.white,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
