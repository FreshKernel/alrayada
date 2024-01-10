import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../data/user/models/user.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/text_input_handler.dart';
import '../../utils/validators/auth_validator.dart';
import '../../utils/validators/global_validator.dart';
import 'city_picker/city_picker.dart';

class UserDataTextInputs extends StatelessWidget {
  const UserDataTextInputs({
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
    IraqGovernorate initialCity
  }) cityInputHandler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PlatformTextFormField(
                textInputAction: TextInputAction.next,
                maxLength: 11,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                enableSuggestions: true,
                controller: labOwnerPhoneNumberInputHandler.controller,
                focusNode: labOwnerPhoneNumberInputHandler.focusNode,
                autofillHints: const [AutofillHints.telephoneNumberLocal],
                hintText: context.loc.labOwnerPhoneNumber,
                cupertino: (_, __) => CupertinoTextFormFieldData(
                  prefix: const Icon(CupertinoIcons.phone_fill),
                  placeholder: context.loc.labOwnerPhoneNumber,
                ),
                material: (_, __) => MaterialTextFormFieldData(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone),
                    labelText: context.loc.labOwnerPhoneNumber,
                  ),
                ),
                minLines: 1,
                maxLines: 1,
                keyboardType: TextInputType.number,
                validator: (value) => AuthValidator.validateIraqPhoneNumber(
                  phoneNumber: value ?? '',
                  localizations: context.loc,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PlatformTextFormField(
                textInputAction: TextInputAction.next,
                maxLength: 11,
                autocorrect: false,
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.number,
                enableSuggestions: true,
                hintText: context.loc.labPhoneNumber,
                controller: labPhoneNumberController,
                autofillHints: const [AutofillHints.telephoneNumberLocal],
                cupertino: (_, __) => CupertinoTextFormFieldData(
                  prefix: const Icon(CupertinoIcons.phone),
                  placeholder: context.loc.labPhoneNumber,
                ),
                material: (_, __) => MaterialTextFormFieldData(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_outlined),
                    labelText: context.loc.labPhoneNumber,
                  ),
                ),
                minLines: 1,
                maxLines: 1,
                validator: (value) => AuthValidator.validateIraqPhoneNumber(
                  phoneNumber: value ?? '',
                  localizations: context.loc,
                ),
              ),
            ),
          ],
        ),
        PlatformTextFormField(
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          hintText: context.loc.labName,
          autofillHints: const [AutofillHints.location],
          controller: labNameController,
          cupertino: (_, __) => CupertinoTextFormFieldData(
            prefix: const Icon(CupertinoIcons.person_2_square_stack),
            placeholder: context.loc.labName,
          ),
          material: (_, __) => MaterialTextFormFieldData(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_history_rounded),
              labelText: context.loc.labName,
            ),
          ),
          minLines: 1,
          maxLines: 1,
          validator: (value) => GlobalValidator.validateTextIsEmpty(
            value ?? '',
            errorMessage: context.loc.pleaseEnterTheLabName,
          ),
        ),
        PlatformTextFormField(
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          hintText: context.loc.labOwnerName,
          autofillHints: const [AutofillHints.name],
          cupertino: (_, __) => CupertinoTextFormFieldData(
            prefix: const Icon(CupertinoIcons.person),
            placeholder: context.loc.labOwnerName,
          ),
          material: (_, __) => MaterialTextFormFieldData(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.location_history),
              labelText: context.loc.labOwnerName,
            ),
          ),
          minLines: 1,
          controller: labOwnerNameController,
          maxLines: 1,
          validator: (value) => GlobalValidator.validateTextIsEmpty(
            value ?? '',
            errorMessage: context.loc.pleaseEnterTheLabOwnerName,
          ),
        ),
        CityPickerFormField(
          onSaved: cityInputHandler.onSaved,
          initialCity: cityInputHandler.initialCity,
        ),
      ],
    );
  }
}
