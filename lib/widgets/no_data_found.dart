import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:lottie/lottie.dart';

import '../gen/assets.gen.dart';
import '../l10n/app_localizations.dart';

final _assets = Assets.lottie.noDataFound.values.map((e) => e.path).toList();

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    required this.onRefresh,
    super.key,
  });

  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final randomAsset = _assets[Random().nextInt(_assets.length)];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(randomAsset),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: PlatformElevatedButton(
              onPressed: onRefresh,
              child: Text(context.loc.refresh),
            ),
          )
        ],
      ),
    );
  }
}
