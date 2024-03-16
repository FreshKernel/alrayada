import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../data/user/auth_exceptions.dart';
import '../../data/user/models/user.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/settings/settings_cubit.dart';
import '../../utils/constants/constants.dart';
import '../../utils/extensions/scaffold_messenger.dart';
import '../../utils/text_input_handler.dart';
import '../../widgets/auth/email_text_field.dart';
import '../../widgets/auth/password_text_field.dart';
import '../../widgets/auth/user_info_text_inputs.dart';
import 'auth_forgot_password.dart';
import 'auth_form.dart';
import 'auth_social_login.dart';

class AuthFormInputs extends StatefulWidget {
  const AuthFormInputs({
    required this.onToggleIsLogin,
    super.key,
  });

  final VoidCallback onToggleIsLogin;

  @override
  State<AuthFormInputs> createState() => _AuthFormInputsState();
}

class _AuthFormInputsState extends State<AuthFormInputs> {
  var _isLoading = false;

  /// Must be the same value in isLogin of [AuthenticationForm]
  var _isLogin = true;

  final _emailController =
      TextEditingController(text: kDebugMode ? 'user@gmail.com' : null);
  final _passwordInputHandler = TextInputHandler(
    TextEditingController(text: kDebugMode ? '?Rocej2dr!zL+wiDlni4' : null),
    FocusNode(),
  );

  // Sign up inputs
  final _confirmPasswordInputHandler = TextInputHandler(
      TextEditingController(text: kDebugMode ? '?Rocej2dr!zL+wiDlni4' : null),
      FocusNode());
  final _labOwnerPhoneNumberInputHandler = TextInputHandler(
      TextEditingController(text: kDebugMode ? '07054726510' : null),
      FocusNode());
  final _labPhoneNumberController =
      TextEditingController(text: kDebugMode ? '07054726510' : null);
  final _labNameController =
      TextEditingController(text: kDebugMode ? 'My Lab Name' : null);
  final _labOwnerNameController =
      TextEditingController(text: kDebugMode ? 'My name' : null);
  var _labCity = IraqGovernorate.defaultCity;
  var _isPrivacyPolicyAgreed = kDebugMode ? true : false;

  String? _emailError;
  String? _passwordError;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();

    _passwordInputHandler.dispose();
    _confirmPasswordInputHandler.dispose();
    _labOwnerPhoneNumberInputHandler.dispose();
    _labPhoneNumberController.dispose();
    _labNameController.dispose();
    _labOwnerNameController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isLogin = !_isLogin);
    widget.onToggleIsLogin();
  }

  Future<void> _onSubmit() async {
    _emailError = null;
    _passwordError = null;

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final authBloc = context.read<AuthCubit>();

    if (!_isLogin) {
      if (!_isPrivacyPolicyAgreed) {
        ScaffoldMessenger.of(context).showSnackBarText(
          context.loc.pleaseAgreeToPrivacyPolicyFirst,
        );
        return;
      }
      final isConfirmCreateAccount = await showAdaptiveDialog<bool>(
            context: context,
            builder: (context) => AlertDialog.adaptive(
              title: Text(context.loc.createNewAccount),
              content:
                  Text(context.loc.authAreYouSureWantToContinueCreateAccount),
              actions: [
                PlatformDialogAction(
                  onPressed: () => context.pop(false),
                  child: Text(context.loc.cancel),
                ),
                PlatformDialogAction(
                  onPressed: () => context.pop(true),
                  child: Text(context.loc.yes),
                ),
              ],
            ),
          ) ??
          false;
      if (!isConfirmCreateAccount) {
        return;
      }
    }
    _formKey.currentState?.save();

    setState(() => _isLoading = true);
    if (_isLogin) {
      await authBloc.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordInputHandler.controller.text,
      );
    } else {
      await authBloc.signUpWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordInputHandler.controller.text,
        userInfo: UserInfo(
          labOwnerPhoneNumber: _labOwnerPhoneNumberInputHandler.controller.text,
          labPhoneNumber: _labPhoneNumberController.text,
          labName: _labNameController.text,
          labOwnerName: _labOwnerNameController.text,
          city: _labCity,
        ),
      );
    }
    setState(() => _isLoading = false);
  }

  List<Widget> get _signUpInputs {
    return [
      PasswordTextField(
        labelText: context.loc.confirmPassword,
        controller: _confirmPasswordInputHandler.controller,
        customError: null,
        textInputAction: TextInputAction.next,
        originalPasswordController: _passwordInputHandler.controller,
        focusNode: _confirmPasswordInputHandler.focusNode,
        nextFocus: _labOwnerPhoneNumberInputHandler.focusNode,
      ),
      UserInfoTextInputs(
        labOwnerPhoneNumberInputHandler: _labOwnerPhoneNumberInputHandler,
        labNameController: _labNameController,
        labPhoneNumberController: _labPhoneNumberController,
        labOwnerNameController: _labOwnerNameController,
        cityInputHandler: (
          initialCity: _labCity,
          onSaved: (newValue) {
            _labCity = newValue ?? IraqGovernorate.defaultCity;
          },
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Checkbox.adaptive(
            value: _isPrivacyPolicyAgreed,
            onChanged: (value) =>
                setState(() => _isPrivacyPolicyAgreed = value ?? false),
          ),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${context.loc.iAgreeTo} ',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                TextSpan(
                  text: context.loc.privacyPolicy,
                  style: Theme.of(context).textTheme.bodyMedium?.apply(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        decorationColor: Colors.blue,
                      ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => launchUrlString(Constants.privacyPolicy),
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> get _formInputs {
    return [
      EmailTextField(
        controller: _emailController,
        customError: _emailError,
        textInputAction: TextInputAction.next,
      ),
      PasswordTextField(
        labelText: context.loc.password,
        controller: _passwordInputHandler.controller,
        customError: _passwordError,
        originalPasswordController: null,
        focusNode: _passwordInputHandler.focusNode,
        textInputAction: _isLogin ? TextInputAction.done : TextInputAction.next,
        nextFocus: _isLogin ? null : _confirmPasswordInputHandler.focusNode,
      ),
      if (!_isLogin)
        if (context.read<SettingsCubit>().state.isAnimationsEnabled)
          ..._signUpInputs.animate().fade().slide()
        else
          ..._signUpInputs,
      Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Align(
          alignment: Alignment.centerRight,
          child: PlatformTextButton(
            onPressed: () => context.push(AuthForgotPassword.routeName,
                extra: _emailController.text),
            child: Text(context.loc.forgotPasswordWithQuestionMark),
          ),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: PlatformElevatedButton(
          onPressed: _onSubmit,
          child: Text(_isLogin ? context.loc.signIn : context.loc.signUp),
        ),
      ),
      const SizedBox(height: 4),
      SizedBox(
        width: double.infinity,
        child: isCupertino(context)
            ? PlatformTextButton(
                onPressed: _toggle,
                child: Text(_isLogin
                    ? context.loc.dontHaveAccountYet
                    : context.loc.alreadyHaveAccount),
              )
            : OutlinedButton(
                onPressed: _toggle,
                child: Text(_isLogin
                    ? context.loc.dontHaveAccountYet
                    : context.loc.alreadyHaveAccount),
              ),
      ),
      const AuthSocialLogin()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final authException = state.exception;
        if (authException != null) {
          switch (authException) {
            case UserNotFoundAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authEmailNotFound,
              );
              setState(() {
                _emailError = context.loc.authEmailNotFound;
              });
              break;
            case EmailVerificationLinkAlreadySentAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.verificationLinkIsAlreadySentWithMinutesToExpire(
                    authException.minutesToExpire.toString()),
              );
              break;
            case EmailAlreadyUsedAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authEmailAlreadyInUse,
              );
              setState(() {
                _emailError = context.loc.authEmailAlreadyInUse;
              });
              break;
            case TooManyRequestsAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authTooManyFailedAttempts,
              );
              return;
            case EmailNeedsVerificationAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.yourAccountNeedToBeActivated,
              );
              break;
            case InvalidCredentialsAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authInvalidEmailOrPassword,
              );
              setState(() {
                _passwordError = context.loc.authInvalidEmailOrPassword;
                _emailError = context.loc.authInvalidEmailOrPassword;
              });
              break;
            case WrongPasswordAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authIncorrectPassword,
              );
              setState(() {
                _passwordError = context.loc.authIncorrectPassword;
              });
              break;
            case UserDisabledAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authUserDisabledErrorMessage,
              );
              break;
            case NetworkAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.pleaseCheckYourInternetConnectionMsg,
              );
              break;
            case OperationNotAllowedAuthException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authProviderIsDisabledMessage,
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
        }
        final userCredential = state.userCredential;
        // The Auth screen will handle switching to the Verify Email screen
        // We want to pop only when the email is not verified
        if (userCredential != null && userCredential.user.isEmailVerified) {
          context.pop();
        }
      },
      child: Builder(
        builder: (context) {
          if (_isLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          return Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: _formInputs,
            ),
          );
        },
      ),
    );
  }
}
