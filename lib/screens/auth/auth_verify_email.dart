import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';

class AuthVerifyEmail extends StatelessWidget {
  const AuthVerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.verifyYourEmail),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Lottie.asset(Assets.lottie.auth.email.path),
              Text(
                context.loc.verifyYourEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'example@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                context.loc.verifyYourEmailDesc,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: PlatformElevatedButton(
                  onPressed: () {},
                  child: Text(context.loc.continueText),
                ),
              ),
              PlatformTextButton(
                onPressed: () {},
                child: Text(context.loc.resendEmail),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
