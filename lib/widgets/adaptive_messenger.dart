import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

class AdaptiveMessenger {
  const AdaptiveMessenger._();

  static Future<void> showPlatformMessage({
    required BuildContext context,
    required String message,
    String? title,
    bool useSnackBarInMaterial = true,
  }) async {
    if (isMaterial(context)) {
      if (useSnackBarInMaterial) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        await ScaffoldMessenger.of(context)
            .showSnackBar(
              SnackBar(
                content: Semantics(
                  label: message,
                  child: Text(message),
                ),
              ),
            )
            .closed;
        return;
      }
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: title != null ? Text(title) : null,
          content: Text(
            message,
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(context.loc.ok),
            )
          ],
        ),
      );
      return;
    }
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: title != null ? Text(title) : null,
          message: Text(message),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => context.pop(),
            child: Text(context.loc.ok),
          ),
        );
      },
    );
  }
}
