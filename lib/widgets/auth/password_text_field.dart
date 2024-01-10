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

  /// Enter the text of the original password to make
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
      child: PlatformTextFormField(
        hintText: widget.labelText ?? translations.confirmPassword,
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
        cupertino: (_, __) => CupertinoTextFormFieldData(
          placeholder: widget.labelText ?? translations.confirmPassword,
          prefix: Row(
            children: [
              const Icon(CupertinoIcons.padlock),
              PlatformIconButton(
                onPressed: () => setState(
                  () => _obscureText = !_obscureText,
                ),
                icon: Icon(_obscureText
                    ? CupertinoIcons.eye_slash
                    : Icons.remove_red_eye),
              )
            ],
          ),
        ),
        material: (_, __) => MaterialTextFormFieldData(
          decoration: InputDecoration(
            labelText: widget.labelText ?? translations.confirmPassword,
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _obscureText = !_obscureText;
              }),
              icon: Icon(_obscureText
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye_rounded),
            ),
          ),
        ),
        validator: (password) {
          if (widget.customError != null) {
            return widget.customError;
          }
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
