import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../logic/user/admin/admin_user_cubit.dart';
import '../../../../utils/extensions/scaffold_messenger_ext.dart';
import '../../../../utils/validators/global_validator.dart';

/// For Admin only
class SendNotificationToUserDialog extends StatefulWidget {
  const SendNotificationToUserDialog({required this.userId, super.key});

  final String userId;

  @override
  State<SendNotificationToUserDialog> createState() =>
      _SendNotificationToUserDialogState();
}

class _SendNotificationToUserDialogState
    extends State<SendNotificationToUserDialog> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();
    context.read<AdminUserCubit>().sendNotificationToUser(
          userId: widget.userId,
          title: _titleController.text,
          body: _messageController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminUserCubit, AdminUserState>(
      listener: (context, state) {
        if (state is AdminUserActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.notificationHasBeenSuccessfullySent,
          );
          context.pop();
        }
      },
      child: AlertDialog(
        title: Text(context.loc.sendNotification),
        icon: Icon(isCupertino(context)
            ? CupertinoIcons.bell
            : Icons.notification_add),
        content: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: context.loc.title),
                textInputAction: TextInputAction.next,
                validator: (value) => GlobalValidator.validateTextIsEmpty(
                  value ?? '',
                  errorMessage: context.loc.thisFieldCantBeEmpty,
                ),
              ),
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(labelText: context.loc.message),
                textInputAction: TextInputAction.send,
                onFieldSubmitted: (value) => _onSubmit(),
                validator: (value) => GlobalValidator.validateTextIsEmpty(
                  value ?? '',
                  errorMessage: context.loc.thisFieldCantBeEmpty,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(context.loc.cancel),
            onPressed: () => context.pop(),
          ),
          BlocBuilder<AdminUserCubit, AdminUserState>(
            builder: (context, state) {
              return TextButton(
                onPressed:
                    state is AdminUserActionInProgress ? null : _onSubmit,
                child: Text(context.loc.submit),
              );
            },
          ),
        ],
      ),
    );
  }
}
