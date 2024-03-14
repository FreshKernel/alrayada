import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/validators/auth_validator.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({
    required this.controller,
    required this.customError,
    required this.textInputAction,
    super.key,
  });

  final TextEditingController controller;
  final String? customError;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.loc.emailAddress,
      child: TextFormField(
        controller: controller,
        textInputAction: textInputAction,
        keyboardType: TextInputType.emailAddress,
        autocorrect: false,
        enableSuggestions: true,
        autofillHints: const [AutofillHints.email],
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          hintText: context.loc.emailAddress,
          prefixIcon: Icon(
            PlatformIcons(context).mail,
          ),
          labelText: context.loc.emailAddress,
          errorText: customError,
        ),
        minLines: 1,
        maxLines: 1,
        validator: (email) {
          return AuthValidator.validateEmail(
            email ?? '',
            localizations: context.loc,
          );
        },
      ),
    );
  }
}
