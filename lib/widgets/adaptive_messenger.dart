import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../l10n/app_localizations.dart';

class AdaptiveMessenger {
  AdaptiveMessenger._();

  static Future<void> showPlatformMessage({
    required BuildContext context,
    required String message,
    String? title,
    bool useSnackBarInMaterial = true,
  }) async {
    final translations = context.loc;
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
      } else {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: title != null
                ? Semantics(
                    label: title,
                    child: Text(title),
                  )
                : null,
            content: Semantics(
              label: message,
              child: Text(
                message,
              ),
            ),
            actions: [
              Semantics(
                label: translations.ok,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(translations.ok),
                ),
              )
            ],
          ),
        );
      }
      return;
    }
    await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: title != null
              ? Semantics(
                  label: title,
                  child: Text(title),
                )
              : null,
          message: Semantics(
            label: message,
            child: Text(message),
          ),
          cancelButton: Semantics(
            label: translations.ok,
            child: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(translations.ok),
            ),
          ),
        );
      },
    );
  }
}
