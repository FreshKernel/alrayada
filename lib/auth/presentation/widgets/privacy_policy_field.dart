import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../common/constants/constants.dart';
import '../../../common/localizations/app_localization_extension.dart';

class PrivacyPolicyCheckboxField extends StatelessWidget {
  const PrivacyPolicyCheckboxField({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox.adaptive(
          value: value,
          onChanged: onChanged,
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
    );
  }
}
