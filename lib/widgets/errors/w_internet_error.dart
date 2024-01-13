import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';

final error = [
  Assets.lottie.noInternet.noInternet1.path,
  Assets.lottie.noInternet.noInternet2.path,
  Assets.lottie.noInternet.noInternet3.path,
];

class InternetError extends StatelessWidget {
  const InternetError({
    required this.onTryAgain,
    super.key,
  });

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final randomAsset = error[Random().nextInt(error.length)];
    final items = [
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
    ];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: items,
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
    final randomAsset = error[Random().nextInt(error.length)];
    final items = [
      Lottie.asset(randomAsset),
      Text(
        context.loc.pleaseCheckYourInternetConnectionMsg,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
    ];
    return PlatformAlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: items,
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
