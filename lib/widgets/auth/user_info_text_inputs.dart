import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../data/user/models/user.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/text_input_handler.dart';
import '../../utils/validators/auth_validator.dart';
import '../../utils/validators/global_validator.dart';
import 'city_picker/city_picker.dart';

class UserInfoTextInputs extends StatelessWidget {
  const UserInfoTextInputs({
    required this.labOwnerPhoneNumberInputHandler,
    required this.labPhoneNumberController,
    required this.labNameController,
    required this.labOwnerNameController,
    required this.cityInputHandler,
    super.key,
  });

  final TextInputHandler labOwnerPhoneNumberInputHandler;
  final TextEditingController labPhoneNumberController;
  final TextEditingController labNameController;
  final TextEditingController labOwnerNameController;
  final ({
    FormFieldSetter<IraqGovernorate> onSaved,
    IraqGovernorate initialCity,
    bool loadCachedCity,
  }) cityInputHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                maxLength: 11,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                enableSuggestions: true,
                controller: labOwnerPhoneNumberInputHandler.controller,
                focusNode: labOwnerPhoneNumberInputHandler.focusNode,
                autofillHints: const [AutofillHints.telephoneNumberLocal],
                decoration: InputDecoration(
                  hintText: context.loc.labOwnerPhoneNumber,
                  prefixIcon: Icon(PlatformIcons(context).phone),
                  labelText: context.loc.labOwnerPhoneNumber,
                ),
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.phone,
                validator: (value) => AuthValidator.validatePhoneNumber(
                  phoneNumber: value ?? '',
                  localizations: context.loc,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                textInputAction: TextInputAction.next,
                maxLength: 11,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.phone,
                enableSuggestions: true,
                controller: labPhoneNumberController,
                autofillHints: const [AutofillHints.telephoneNumberLocal],
                decoration: InputDecoration(
                  hintText: context.loc.labPhoneNumber,
                  prefixIcon: Icon(
                    isCupertino(context)
                        ? CupertinoIcons.phone
                        : Icons.phone_outlined,
                  ),
                  labelText: context.loc.labPhoneNumber,
                ),
                minLines: 1,
                maxLines: 1,
                validator: (value) => AuthValidator.validatePhoneNumber(
                  phoneNumber: value ?? '',
                  localizations: context.loc,
                ),
              ),
            ),
          ],
        ),
        TextFormField(
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.location],
          controller: labNameController,
          decoration: InputDecoration(
            hintText: context.loc.labName,
            prefixIcon: Icon(isCupertino(context)
                ? CupertinoIcons.person_2_square_stack
                : Icons.location_history_rounded),
            labelText: context.loc.labName,
          ),
          minLines: 1,
          maxLines: 1,
          validator: (value) => GlobalValidator.validateTextIsEmpty(
            value ?? '',
            errorMessage: context.loc.pleaseEnterTheLabName,
          ),
        ),
        TextFormField(
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          autofillHints: const [AutofillHints.name],
          decoration: InputDecoration(
            hintText: context.loc.labOwnerName,
            prefixIcon: Icon(isCupertino(context)
                ? CupertinoIcons.person
                : Icons.location_history),
            labelText: context.loc.labOwnerName,
          ),
          minLines: 1,
          controller: labOwnerNameController,
          maxLines: 1,
          validator: (value) => GlobalValidator.validateTextIsEmpty(
            value ?? '',
            errorMessage: context.loc.pleaseEnterTheLabOwnerName,
          ),
        ),
        // TODO: Update how the CityPickerFormField work, don't use onSaved to avoid some bugs
        CityPickerFormField(
          onSaved: cityInputHandler.onSaved,
          initialCity: cityInputHandler.initialCity,
          loadCachedCity: cityInputHandler.loadCachedCity,
        ),
      ],
    );
  }
}
