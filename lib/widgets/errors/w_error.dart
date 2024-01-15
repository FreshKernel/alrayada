import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../../gen/assets.gen.dart';
import '../../l10n/app_localizations.dart';

class ErrorWithTryAgain extends StatelessWidget {
  const ErrorWithTryAgain({
    required this.onTryAgain,
    super.key,
  });

  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LayoutBuilder(
              builder: (context, constranints) {
                final asset = Assets.lottie.errors.unknownError.path;
                final isLandscape =
                    MediaQuery.orientationOf(context) == Orientation.landscape;
                if (isLandscape) {
                  return Lottie.asset(
                    asset,
                    width: constranints.maxWidth * 0.6,
                    height: 180,
                  );
                }
                return Lottie.asset(asset);
              },
            ),
            const SizedBox(height: 12),
            if (onTryAgain != null)
              PlatformElevatedButton(
                onPressed: onTryAgain,
                child: Text(context.loc.tryAgain),
              )
          ],
        ),
      ),
    );
  }
}
