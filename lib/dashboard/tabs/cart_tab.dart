import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../common/localizations/app_localization_extension.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  static const id = 'cartTab';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      context.loc.orderTotal,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '${50.round().toStringAsFixed(2).replaceFirst('.00', '')}\$',
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                PlatformElevatedButton(
                  onPressed: () async {},
                  cupertino: (context, platform) => CupertinoElevatedButtonData(
                    padding: const EdgeInsets.all(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PlatformIcons(context).shoppingCart,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        context.loc.checkout,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
