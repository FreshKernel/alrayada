import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

/// A dialog that return either true or false
class OkCancelDialog extends StatelessWidget {
  const OkCancelDialog({
    required this.title,
    required this.content,
    super.key,
    this.cancel,
    this.ok,
  });

  final Widget title;
  final Widget content;
  final Widget? cancel;
  final Widget? ok;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: title,
      content: content,
      actions: [
        PlatformDialogAction(
          onPressed: () => context.pop(false),
          child: cancel ?? Text(context.loc.cancel),
        ),
        PlatformDialogAction(
          onPressed: () => context.pop(true),
          material: (context, platform) => MaterialDialogActionData(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
          cupertino: (context, platform) => CupertinoDialogActionData(
            isDefaultAction: true,
          ),
          child: ok ?? Text(context.loc.ok),
        ),
      ],
    );
  }
}

Future<bool> showOkCancelDialog({
  required BuildContext context,
  required Widget title,
  required Widget content,
  Widget? cancel,
  Widget? ok,
}) async {
  final isOk = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => OkCancelDialog(
      title: title,
      content: content,
      cancel: cancel,
      ok: ok,
    ),
  );
  return isOk ?? false;
}
