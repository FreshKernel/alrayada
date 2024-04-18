import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';

final _errors = Assets.lottie.noInternet.values.map((e) => e.path).toList();

class InternetError extends StatelessWidget {
  const InternetError({
    required this.onTryAgain,
    super.key,
  });

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final randomAsset = _errors[Random().nextInt(_errors.length)];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(randomAsset),
          Text(
            context.loc.pleaseCheckYourInternetConnectionMsg,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (onTryAgain != null) ...[
            const SizedBox(height: 8),
            PlatformElevatedButton(
              onPressed: onTryAgain,
              child: Text(context.loc.tryAgain),
            ),
          ]
        ],
      ),
    );
  }
}

class InternetErrorDialog extends StatelessWidget {
  const InternetErrorDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final translations = context.loc;
    final randomAsset = _errors[Random().nextInt(_errors.length)];
    return AlertDialog.adaptive(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(randomAsset),
          Text(
            context.loc.pleaseCheckYourInternetConnectionMsg,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(translations.close),
        )
      ],
    );
  }
}
