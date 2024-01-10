// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsStateImpl _$$SettingsStateImplFromJson(Map<String, dynamic> json) =>
    _$SettingsStateImpl(
      themeMode: $enumDecodeNullable(_$ThemeModeEnumMap, json['themeMode']) ??
          ThemeMode.system,
      isAnimationsEnabled: json['isAnimationsEnabled'] as bool? ?? true,
      confirmDeleteCartItem: json['confirmDeleteCartItem'] as bool? ?? false,
      clearCartAfterCheckout: json['clearCartAfterCheckout'] as bool? ?? true,
      forceUseScrollableChart:
          json['forceUseScrollableChart'] as bool? ?? false,
      useMonthNumberInChart: json['useMonthNumberInChart'] as bool? ?? false,
      unFocusAfterSendMsg: json['unFocusAfterSendMsg'] as bool? ?? true,
      useClassicMsgBubble: json['useClassicMsgBubble'] as bool? ?? false,
      showOnBoardingScreen: json['showOnBoardingScreen'] as bool? ?? true,
      showOrderItemNotes: json['showOrderItemNotes'] as bool? ?? true,
      layoutMode:
          $enumDecodeNullable(_$AppLayoutModeEnumMap, json['layoutMode']) ??
              AppLayoutMode.auto,
    );

Map<String, dynamic> _$$SettingsStateImplToJson(_$SettingsStateImpl instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'isAnimationsEnabled': instance.isAnimationsEnabled,
      'confirmDeleteCartItem': instance.confirmDeleteCartItem,
      'clearCartAfterCheckout': instance.clearCartAfterCheckout,
      'forceUseScrollableChart': instance.forceUseScrollableChart,
      'useMonthNumberInChart': instance.useMonthNumberInChart,
      'unFocusAfterSendMsg': instance.unFocusAfterSendMsg,
      'useClassicMsgBubble': instance.useClassicMsgBubble,
      'showOnBoardingScreen': instance.showOnBoardingScreen,
      'showOrderItemNotes': instance.showOrderItemNotes,
      'layoutMode': _$AppLayoutModeEnumMap[instance.layoutMode]!,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};

const _$AppLayoutModeEnumMap = {
  AppLayoutMode.auto: 'auto',
  AppLayoutMode.small: 'small',
  AppLayoutMode.large: 'large',
};
