import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/validators/auth_validator.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    required this.labelText,
    required this.controller,
    required this.textInputAction,
    required this.customError,
    required this.originalPasswordController,
    required this.nextFocus,
    required this.focusNode,
    super.key,
  });

  final String? labelText;

  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final String? customError;

  /// Pass the original password controller (the first one) to make
  /// this text field as confirm password
  final TextEditingController? originalPasswordController;
  final FocusNode? nextFocus;
  final FocusNode? focusNode;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  var _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    return Semantics(
      label: translations.confirmPassword,
      child: TextFormField(
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        onEditingComplete: () {
          if (widget.nextFocus != null) {
            widget.nextFocus!.requestFocus();
            return;
          }
          widget.focusNode?.unfocus();
        },
        textCapitalization: TextCapitalization.none,
        obscureText: _obscureText,
        enableSuggestions: false,
        autocorrect: false,
        minLines: 1,
        maxLines: 1,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.labelText ?? translations.confirmPassword,
          labelText: widget.labelText ?? translations.confirmPassword,
          prefixIcon: Icon(
            isCupertino(context) ? CupertinoIcons.padlock : Icons.lock_outlined,
          ),
          suffixIcon: IconButton(
            onPressed: () => setState(() {
              _obscureText = !_obscureText;
            }),
            icon: Icon(_obscureText
                ? PlatformIcons(context).eyeSlash
                : PlatformIcons(context).eyeSolid),
          ),
          errorText: widget.customError,
        ),
        validator: (password) {
          if (widget.originalPasswordController != null) {
            return AuthValidator.validateConfirmPassword(
              password: password ?? '',
              confirmPassword: widget.originalPasswordController?.text ?? '',
              localizations: context.loc,
            );
          }
          return AuthValidator.validatePassword(
            password ?? '',
            localizations: context.loc,
          );
        },
      ),
    );
  }
}
