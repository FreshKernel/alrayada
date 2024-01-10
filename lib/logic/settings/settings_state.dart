part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default(true) bool isAnimationsEnabled,
    @Default(false) bool confirmDeleteCartItem,
    @Default(true) bool clearCartAfterCheckout,
    @Default(false) bool forceUseScrollableChart,
    @Default(false) bool useMonthNumberInChart,
    @Default(true) bool unFocusAfterSendMsg,
    @Default(false) bool useClassicMsgBubble,
    @Default(true) bool showOnBoardingScreen,
    @Default(true) bool showOrderItemNotes,
    @Default(AppLayoutMode.auto) AppLayoutMode layoutMode,
  }) = _SettingsState;
  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}

enum AppLayoutMode {
  auto,
  small,
  large,
}
