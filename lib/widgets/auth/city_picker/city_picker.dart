import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../data/location/geo_location_service.dart';
import '../../../data/user/models/user.dart';
import '../../../l10n/app_localizations.dart';
import '../../../logic/settings/settings_cubit.dart';
import '../../adaptive_messenger.dart';

class CityPickerFormField extends StatefulWidget {
  const CityPickerFormField({
    required this.onSaved,
    required this.initialCity,
    required this.loadCachedCity,
    super.key,
  });

  final FormFieldSetter<IraqGovernorate> onSaved;
  final IraqGovernorate initialCity;

  /// After loading the [initialCity] should we use the last city located by Gps?
  /// true for sign in screeen, false for profile screen
  final bool loadCachedCity;

  @override
  State<CityPickerFormField> createState() => _CityPickerFormFieldState();
}

class _CityPickerFormFieldState extends State<CityPickerFormField> {
  late IraqGovernorate _selectedCity;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCity = widget.initialCity;
    if (!widget.loadCachedCity) {
      return;
    }
    GeoLocationService.instance.getCachedLocation().then((location) {
      if (location == null) return;
      setState(() {
        _selectedCity = IraqGovernorate.fromString(location.city);
      });
    });
  }

  Future<void> _setCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final location = await GeoLocationService.instance.getLocation();
      setState(() {
        _selectedCity = IraqGovernorate.fromString(location.city);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      AdaptiveMessenger.showPlatformMessage(
        context: context,
        message: e.toString(),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isCupertino(context)) {
      return PlatformTextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(CupertinoIcons.location),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                context.loc.selectedCity(
                  _selectedCity.getTranslatedCityName(
                    localizations: context.loc,
                  ),
                ),
              ),
            ),
          ],
        ),
        onPressed: () async {
          final scrollController = FixedExtentScrollController(
            initialItem: IraqGovernorate.values.indexOf(_selectedCity),
          );
          await showCupertinoModalPopup(
            context: context,
            builder: (context) {
              return CupertinoActionSheet(
                title: Text(context.loc.chooseTheLabCity),
                message: PlatformIconButton(
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(CupertinoIcons.location_solid),
                      Text(context.loc.autoDetect),
                    ],
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          final settingsBloc = context.read<SettingsCubit>();
                          await _setCurrentLocation();

                          final itemIndex =
                              IraqGovernorate.values.indexOf(_selectedCity);
                          if (settingsBloc.state.isAnimationsEnabled) {
                            await scrollController.animateToItem(
                              itemIndex,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                            return;
                          }
                          scrollController.jumpToItem(itemIndex);
                        },
                ),
                actions: [
                  SizedBox(
                    height: 216,
                    child: SafeArea(
                      top: false,
                      child: CupertinoPicker(
                        itemExtent: 32.0,
                        scrollController: scrollController,
                        onSelectedItemChanged: (newItem) => setState(() =>
                            _selectedCity = IraqGovernorate.values[newItem]),
                        children: IraqGovernorate.values
                            .map(
                              (e) => DropdownMenuItem<IraqGovernorate>(
                                value: e,
                                child: Center(
                                  child: Text(e.getTranslatedCityName(
                                    localizations: context.loc,
                                  )),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => context.pop(),
                  child: Text(context.loc.close),
                ),
              );
            },
          );
          scrollController.dispose();
        },
      );
    }
    return DropdownButtonFormField<IraqGovernorate>(
      value: _selectedCity,
      onSaved: widget.onSaved,
      onChanged: (value) =>
          setState(() => _selectedCity = value ?? IraqGovernorate.defaultCity),
      items: IraqGovernorate.values
          .map(
            (e) => DropdownMenuItem<IraqGovernorate>(
              value: e,
              child: Text(e.getTranslatedCityName(
                localizations: context.loc,
              )),
            ),
          )
          .toList(),
      decoration: InputDecoration(
        labelText: context.loc.city,
        suffixIcon: const Icon(Icons.location_city),
        icon: IconButton(
          onPressed: (_isLoading ? null : _setCurrentLocation),
          icon: const Icon(Icons.gps_fixed),
        ),
      ),
    );
  }
}
