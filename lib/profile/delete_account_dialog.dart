import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../auth/logic/user_cubit.dart';
import '../common/localizations/app_localization_extension.dart';
import 'profile_screen.dart';

// TODO: Should I use OkCancelDialog?

/// To be used in [ProfileScreen]
class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _confirmationController = TextEditingController();

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.loc.confirmDeleteAccount),
      content: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.loc.authAccountDeleteConfirmation),
            const SizedBox(height: 6),
            TextField(
              controller: _confirmationController,
              decoration: InputDecoration(
                hintText: context.loc.delete,
                labelText: context.loc.deleteAccount,
              ),
              onChanged: (v) => setState(() {}),
            ),
          ],
        ),
      ),
      actions: [
        PlatformDialogAction(
          onPressed: () => context.pop(),
          child: Text(context.loc.cancel),
        ),
        BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            return PlatformDialogAction(
              onPressed: (_confirmationController.text == context.loc.delete &&
                      state is! UserDeleteInProgress)
                  ? () {
                      context.pop(); // Close the dialog
                      context.read<UserCubit>().deleteAccount();
                    }
                  : null,
              child: Text(context.loc.delete),
              material: (context, platform) => MaterialDialogActionData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
              cupertino: (context, platform) => CupertinoDialogActionData(
                isDefaultAction: true,
              ),
            );
          },
        ),
      ],
    );
  }
}
