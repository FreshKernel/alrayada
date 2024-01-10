import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'settings_cubit.freezed.dart';
part 'settings_cubit.g.dart';
part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void setThemeMode(ThemeMode newThemeMode) {
    emit(state.copyWith(themeMode: newThemeMode));
  }

  void toggleSetAnimationsEnabled() {
    final isAnimationEnabled = !state.isAnimationsEnabled;
    emit(state.copyWith(isAnimationsEnabled: isAnimationEnabled));
  }

  void toggleConfirmDeleteCartItem() {
    final confirmDeleteCartItem = !state.confirmDeleteCartItem;
    emit(state.copyWith(confirmDeleteCartItem: confirmDeleteCartItem));
  }

  void toggleClearCartAfterCheckout() {
    final clearCartAfterCheckout = !state.clearCartAfterCheckout;
    emit(state.copyWith(clearCartAfterCheckout: clearCartAfterCheckout));
  }

  void toggleForceUseScrollableChart() {
    final forceUseScrollableChart = !state.forceUseScrollableChart;
    emit(state.copyWith(forceUseScrollableChart: forceUseScrollableChart));
  }

  void toggleUseMonthNumberInChart() {
    final useMonthNumberInChart = !state.useMonthNumberInChart;
    emit(state.copyWith(useMonthNumberInChart: useMonthNumberInChart));
  }

  void toggleUnFocusAfterSendMsg() {
    final unFocusAfterSendMsg = !state.unFocusAfterSendMsg;
    emit(state.copyWith(unFocusAfterSendMsg: unFocusAfterSendMsg));
  }

  void toggleUseClassicMsgBubble() {
    final useClassicMsgBubble = !state.useClassicMsgBubble;
    emit(state.copyWith(useClassicMsgBubble: useClassicMsgBubble));
  }

  void dontShowOnBoardingScreen() {
    const showOnBoardingScreen = false;
    emit(state.copyWith(showOnBoardingScreen: showOnBoardingScreen));
  }

  void toggleShowOrderItemNotes() {
    final showOrderItemNotes = !state.showOrderItemNotes;
    emit(state.copyWith(showOrderItemNotes: showOrderItemNotes));
  }

  void clearAllPrefs() {
    clear();
    // Don't show the on-boarding screen on next app launch
    emit(const SettingsState().copyWith(showOnBoardingScreen: false));
  }

  @override
  SettingsState? fromJson(Map<String, dynamic> json) {
    return SettingsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SettingsState state) {
    return state.toJson();
  }
}
