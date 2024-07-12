import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../common/environment_variables.dart';
import '../../common/extensions/scaffold_messenger_ext.dart';
import '../../common/localizations/app_localization_extension.dart';
import '../../common/text_input_handler.dart';
import '../../settings/logic/settings_cubit.dart';
import '../data/models/user.dart';
import '../data/user_exceptions.dart';
import '../logic/user_cubit.dart';
import 'auth_forgot_password.dart';
import 'auth_form.dart';
import 'auth_social_login.dart';
import 'widgets/email_text_field.dart';
import 'widgets/password_text_field.dart';
import 'widgets/privacy_policy_field.dart';
import 'widgets/user_info_text_inputs.dart';

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
  /// Must be the same value in isLogin of [AuthenticationForm]
  var _isLogin = true;

  final _emailController = TextEditingController(
      text: getEnvironmentVariables().isProductionMode && kDebugMode
          ? 'user@gmail.com'
          : null);
  final _passwordInputHandler = TextInputHandler(
    TextEditingController(
        text: getEnvironmentVariables().isProductionMode && kDebugMode
            ? '?Rocej2dr!zL+wiDlni4'
            : null),
    FocusNode(),
  );

  // Sign up inputs
  final _confirmPasswordInputHandler = TextInputHandler(
      TextEditingController(
          text: getEnvironmentVariables().isProductionMode && kDebugMode
              ? '?Rocej2dr!zL+wiDlni4'
              : null),
      FocusNode());

  final _labOwnerPhoneNumberInputHandler = TextInputHandler(
      TextEditingController(
          text: getEnvironmentVariables().isProductionMode && kDebugMode
              ? '07054726510'
              : null),
      FocusNode());
  final _labPhoneNumberController = TextEditingController(
      text: getEnvironmentVariables().isProductionMode && kDebugMode
          ? '07054726510'
          : null);
  final _labNameController = TextEditingController(
      text: getEnvironmentVariables().isProductionMode && kDebugMode
          ? 'My Lab Name'
          : null);
  final _labOwnerNameController = TextEditingController(
      text: getEnvironmentVariables().isProductionMode && kDebugMode
          ? 'My name'
          : null);
  var _labCity = IraqGovernorate.defaultCity;
  var _isPrivacyPolicyAgreed =
      getEnvironmentVariables().isProductionMode && kDebugMode ? true : false;

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

    final userBloc = context.read<UserCubit>();

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
    // Important, otherwise the selected city won't saved
    _formKey.currentState?.save();

    if (_isLogin) {
      await userBloc.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordInputHandler.controller.text,
      );
    } else {
      await userBloc.signUpWithEmailAndPassword(
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
          onSaved: (newValue) =>
              _labCity = newValue ?? IraqGovernorate.defaultCity,
          loadCachedCity: true,
        ),
      ),
      const SizedBox(height: 8),
      PrivacyPolicyCheckboxField(
        value: _isPrivacyPolicyAgreed,
        onChanged: (value) =>
            setState(() => _isPrivacyPolicyAgreed = value ?? false),
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
            onPressed: () => context.push(AuthForgotPasswordScreen.routeName,
                extra: _emailController.text),
            child: Text(context.loc.forgotPasswordWithQuestionMark),
          ),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: FilledButton(
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
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoginFailure) {
          final exception = state.exception;
          switch (exception) {
            case EmailNotFoundUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authEmailNotFound,
              );
              setState(() => _emailError = context.loc.authEmailNotFound);
              break;
            case EmailVerificationLinkAlreadySentUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.verificationLinkIsAlreadySentWithMinutesToExpire(
                    exception.minutesToExpire.toString()),
              );
              break;
            case EmailAlreadyUsedUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authEmailAlreadyInUse,
              );
              setState(() {
                _emailError = context.loc.authEmailAlreadyInUse;
              });
              break;
            case TooManyRequestsUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authTooManyFailedAttempts,
              );
              return;
            case EmailNeedsVerificationUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.yourAccountNeedToBeActivated,
              );
              break;
            case InvalidCredentialsUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authIncorrectEmailOrPassword,
              );
              setState(() {
                _passwordError = context.loc.authIncorrectEmailOrPassword;
                _emailError = context.loc.authIncorrectEmailOrPassword;
              });
              break;
            case WrongPasswordUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authIncorrectPassword,
              );
              setState(() {
                _passwordError = context.loc.authIncorrectPassword;
              });
              break;
            case UserDisabledUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authUserDisabledErrorMessage,
              );
              break;
            case NetworkUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.pleaseCheckYourInternetConnectionMsg,
              );
              break;
            case OperationNotAllowedUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.authProviderIsDisabledMessage,
              );
              break;
            case UnknownUserException():
              ScaffoldMessenger.of(context).showSnackBarText(
                context.loc.unknownErrorWithMsg(exception.message),
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
        if (state is UserLoginSuccess) {
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
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoginInProgress) {
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
