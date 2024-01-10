import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../data/user/models/user.dart';
import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/settings/settings_cubit.dart';
import '../../utils/text_input_handler.dart';
import '../../widgets/auth/email_text_field.dart';
import '../../widgets/auth/password_text_field.dart';
import '../../widgets/auth/user_data_text_inputs.dart';
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

  final _emailController = TextEditingController();
  final _passwordInputHandler =
      TextInputHandler(TextEditingController(), FocusNode());
  final _confirmPasswordInputHandler =
      TextInputHandler(TextEditingController(), FocusNode());
  final _labOwnerPhoneNumberInputHandler =
      TextInputHandler(TextEditingController(), FocusNode());
  final _labPhoneNumberController = TextEditingController();
  final _labNameController = TextEditingController();
  final _labOwnerNameController = TextEditingController();
  var _labCity = IraqGovernorate.defaultCity;

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

  Future<void> _submit() async {
    _emailError = null;
    _passwordError = null;
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    final authBloc = context.read<AuthCubit>();
    setState(() => _isLoading = true);
    if (_isLogin) {
      await context.read<AuthCubit>().signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordInputHandler.controller.text,
          );
    } else {
      final isConfirmCreateAccount = await showAdaptiveDialog<bool>(
            context: context,
            builder: (context) => PlatformAlertDialog(
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
      await authBloc.signUpWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordInputHandler.controller.text,
        userData: UserData(
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
        controller: null,
        customError: null,
        textInputAction: TextInputAction.next,
        originalPasswordController: _passwordInputHandler.controller,
        focusNode: _confirmPasswordInputHandler.focusNode,
        nextFocus: _labOwnerPhoneNumberInputHandler.focusNode,
      ),
      UserDataTextInputs(
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
            onPressed: () => showPlatformDialog(
              context: context,
              builder: (context) => const AuthForgotPasswordDialog(),
            ),
            child: Text(context.loc.forgotPassword),
          ),
        ),
      ),
      SizedBox(
        width: double.infinity,
        child: PlatformElevatedButton(
          onPressed: _submit,
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
        if (state.userCredential != null) {
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
            child: isCupertino(context)
                ? CupertinoFormSection.insetGrouped(
                    margin: EdgeInsets.zero,
                    backgroundColor:
                        CupertinoTheme.of(context).barBackgroundColor,
                    children: _formInputs,
                  )
                : Column(
                    children: _formInputs,
                  ),
          );
        },
      ),
    );
  }
}
