part of 'settings_cubit.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    // General
    @Default(AppLanguague.system) AppLanguague appLanguague,
    @Default(AppThemeMode.system) AppThemeMode themeMode,
    @Default(AppThemeSystem.material3) AppThemeSystem themeSystem,
    @Default(AppLayoutMode.auto) AppLayoutMode layoutMode,
    @Default(true) bool isAnimationsEnabled,
    @Default(false) darkDuringDayInAutoMode,
    @Default(true) bool showOnBoardingScreen,
    // Cart
    @Default(false) bool confirmDeleteCartItem,
    @Default(true) bool clearCartAfterCheckout,
    // Statistics
    @Default(false) bool forceUseScrollableChart,
    @Default(false) bool useMonthNumberInChart,
    // Support chat
    @Default(true) bool unFocusAfterSendMsg,
    @Default(false) bool useClassicMsgBubble,
    // Orders
    @Default(true) bool showOrderItemNotes,
  }) = _SettingsState;
  factory SettingsState.fromJson(Map<String, Object?> json) =>
      _$SettingsStateFromJson(json);
}
