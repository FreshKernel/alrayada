// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsStateImpl _$$SettingsStateImplFromJson(Map<String, dynamic> json) =>
    _$SettingsStateImpl(
      appLanguague:
          $enumDecodeNullable(_$AppLanguagueEnumMap, json['appLanguague']) ??
              AppLanguague.system,
      themeMode:
          $enumDecodeNullable(_$AppThemeModeEnumMap, json['themeMode']) ??
              AppThemeMode.system,
      themeSystem:
          $enumDecodeNullable(_$AppThemeSystemEnumMap, json['themeSystem']) ??
              AppThemeSystem.material3,
      useDynamicColors: json['useDynamicColors'] as bool? ?? true,
      layoutMode:
          $enumDecodeNullable(_$AppLayoutModeEnumMap, json['layoutMode']) ??
              AppLayoutMode.auto,
      isAnimationsEnabled: json['isAnimationsEnabled'] as bool? ?? true,
      darkDuringDayInAutoMode: json['darkDuringDayInAutoMode'] ?? false,
      showOnBoardingScreen: json['showOnBoardingScreen'] as bool? ?? true,
      confirmDeleteCartItem: json['confirmDeleteCartItem'] as bool? ?? false,
      clearCartAfterCheckout: json['clearCartAfterCheckout'] as bool? ?? true,
      forceUseScrollableChart:
          json['forceUseScrollableChart'] as bool? ?? false,
      useMonthNumberInChart: json['useMonthNumberInChart'] as bool? ?? false,
      unFocusAfterSendMsg: json['unFocusAfterSendMsg'] as bool? ?? true,
      useClassicMsgBubble: json['useClassicMsgBubble'] as bool? ?? false,
      showOrderItemNotes: json['showOrderItemNotes'] as bool? ?? true,
    );

Map<String, dynamic> _$$SettingsStateImplToJson(_$SettingsStateImpl instance) =>
    <String, dynamic>{
      'appLanguague': _$AppLanguagueEnumMap[instance.appLanguague]!,
      'themeMode': _$AppThemeModeEnumMap[instance.themeMode]!,
      'themeSystem': _$AppThemeSystemEnumMap[instance.themeSystem]!,
      'useDynamicColors': instance.useDynamicColors,
      'layoutMode': _$AppLayoutModeEnumMap[instance.layoutMode]!,
      'isAnimationsEnabled': instance.isAnimationsEnabled,
      'darkDuringDayInAutoMode': instance.darkDuringDayInAutoMode,
      'showOnBoardingScreen': instance.showOnBoardingScreen,
      'confirmDeleteCartItem': instance.confirmDeleteCartItem,
      'clearCartAfterCheckout': instance.clearCartAfterCheckout,
      'forceUseScrollableChart': instance.forceUseScrollableChart,
      'useMonthNumberInChart': instance.useMonthNumberInChart,
      'unFocusAfterSendMsg': instance.unFocusAfterSendMsg,
      'useClassicMsgBubble': instance.useClassicMsgBubble,
      'showOrderItemNotes': instance.showOrderItemNotes,
    };

const _$AppLanguagueEnumMap = {
  AppLanguague.system: 'system',
  AppLanguague.en: 'en',
  AppLanguague.ar: 'ar',
};

const _$AppThemeModeEnumMap = {
  AppThemeMode.dark: 'dark',
  AppThemeMode.light: 'light',
  AppThemeMode.system: 'system',
  AppThemeMode.auto: 'auto',
  AppThemeMode.random: 'random',
};

const _$AppThemeSystemEnumMap = {
  AppThemeSystem.material3: 'material3',
  AppThemeSystem.material2: 'material2',
  AppThemeSystem.cupertino: 'cupertino',
};

const _$AppLayoutModeEnumMap = {
  AppLayoutMode.auto: 'auto',
  AppLayoutMode.small: 'small',
  AppLayoutMode.large: 'large',
};
