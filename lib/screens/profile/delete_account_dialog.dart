import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../logic/auth/auth_cubit.dart';
import './profile_screen.dart';

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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.loc.cancel),
        ),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return PlatformDialogAction(
              onPressed: (_confirmationController.text == context.loc.delete &&
                      state is! AuthDeleteInProgress)
                  ? () {
                      context.pop(); // Close the dialog
                      context.read<AuthCubit>().deleteAccount();
                    }
                  : null,
              child: Text(context.loc.delete),
            );
          },
        ),
      ],
    );
  }
}
