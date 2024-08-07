import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../common/environment_variables.dart';
import '../../common/extensions/scaffold_messenger_ext.dart';
import '../../common/gen/assets.gen.dart';
import '../../common/localizations/app_localization_extension.dart';
import '../../common/text_input_handler.dart';
import '../data/models/user.dart';
import '../data/user_social_login.dart';
import '../logic/user_cubit.dart';
import 'widgets/privacy_policy_field.dart';
import 'widgets/user_info_text_inputs.dart';

@immutable
class AuthSocialLoginSignUpScreenArgs {
  const AuthSocialLoginSignUpScreenArgs({
    required this.initialLabOwnerNameText,
    required this.socialLogin,
  });

  final String initialLabOwnerNameText;
  final SocialLogin socialLogin;
}

/// Request the sign up user data when do social login and
/// there is no user in the database
class AuthSocialLoginSignUpScreen extends StatefulWidget {
  const AuthSocialLoginSignUpScreen({required this.args, super.key});

  final AuthSocialLoginSignUpScreenArgs args;
  static const routeName = '/auth-social-login-signup';

  @override
  State<AuthSocialLoginSignUpScreen> createState() =>
      _AuthSocialLoginSignUpScreenState();
}

class _AuthSocialLoginSignUpScreenState
    extends State<AuthSocialLoginSignUpScreen> {
  final _formKey = GlobalKey<FormState>();

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

  @override
  void initState() {
    super.initState();
    _labOwnerNameController.text = widget.args.initialLabOwnerNameText;
  }

  @override
  void dispose() {
    _labOwnerPhoneNumberInputHandler.dispose();
    _labPhoneNumberController.dispose();
    _labNameController.dispose();
    _labOwnerNameController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    if (!_isPrivacyPolicyAgreed) {
      ScaffoldMessenger.of(context).showSnackBarText(
        context.loc.pleaseAgreeToPrivacyPolicyFirst,
      );
      return;
    }
    _formKey.currentState?.save();
    context.pop();
    context.read<UserCubit>().authenticateWithSocialLogin(
          widget.args.socialLogin,
          userInfo: UserInfo(
            labOwnerPhoneNumber:
                _labOwnerPhoneNumberInputHandler.controller.text,
            labPhoneNumber: _labPhoneNumberController.text,
            labName: _labNameController.text,
            labOwnerName: _labOwnerNameController.text,
            city: _labCity,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.signUp),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Lottie.asset(
                      Assets.lottie.auth.userData.path,
                      height: 300,
                    ),
                  ),
                  Text(
                    context.loc.signUp,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.loc.enterSignUpDataDesc,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  UserInfoTextInputs(
                    labOwnerPhoneNumberInputHandler:
                        _labOwnerPhoneNumberInputHandler,
                    labPhoneNumberController: _labPhoneNumberController,
                    labOwnerNameController: _labOwnerNameController,
                    labNameController: _labNameController,
                    cityInputHandler: (
                      initialCity: _labCity,
                      onSaved: (newValue) =>
                          _labCity = newValue ?? IraqGovernorate.defaultCity,
                      loadCachedCity: true,
                    ),
                  ),
                  PrivacyPolicyCheckboxField(
                    value: _isPrivacyPolicyAgreed,
                    onChanged: (value) =>
                        setState(() => _isPrivacyPolicyAgreed = value ?? false),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: PlatformElevatedButton(
                      onPressed: _onSubmit,
                      child: Text(context.loc.continueText),
                    ),
                  ),
                  Center(
                    child: PlatformTextButton(
                      onPressed: () => context.pop(),
                      child: Text(context.loc.cancel),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
