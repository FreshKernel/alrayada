import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../common/extensions/scaffold_messenger_ext.dart';
import '../../../common/global_validator.dart';
import '../../../common/localizations/app_localization_extension.dart';
import '../logic/admin_user_cubit.dart';

class AdminSendNotificationToUserDialog extends StatefulWidget {
  const AdminSendNotificationToUserDialog({required this.userId, super.key});

  final String userId;

  @override
  State<AdminSendNotificationToUserDialog> createState() =>
      _AdminSendNotificationToUserDialogState();
}

class _AdminSendNotificationToUserDialogState
    extends State<AdminSendNotificationToUserDialog> {
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
        if (state.status is AdminUserActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBarText(
            context.loc.notificationHasBeenSuccessfullySent,
          );
          context.pop();
        }
      },
      child: AlertDialog(
        title: Text(context.loc.sendNotification),
        icon: Icon(
          isCupertino(context) ? CupertinoIcons.bell : Icons.notification_add,
        ),
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
                  errorMessage: context.loc
                      .thisFieldCantBeEmpty, // TODO: there is also context.loc.fieldShouldNotBeEmpty, remove one of them
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
                onPressed: state.status is AdminUserActionInProgress
                    ? null
                    : _onSubmit,
                child: Text(context.loc.submit),
              );
            },
          ),
        ],
      ),
    );
  }
}
