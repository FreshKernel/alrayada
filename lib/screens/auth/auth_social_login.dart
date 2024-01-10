import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';

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
                semanticsLabel: label,
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
        _buildButton(
          label: context.loc.loginWithGoogle,
          icon: SvgPicture.asset(
            Assets.svg.icGoogle.path,
            height: 25,
            width: 25,
          ),
          onPressed: () {},
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
          onPressed: () {},
          backgroundColor: Colors.black,
          fontColor: Colors.white,
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
