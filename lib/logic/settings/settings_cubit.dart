import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'settings_data.dart';

part 'settings_cubit.freezed.dart';
part 'settings_cubit.g.dart';
part 'settings_state.dart';

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void updateSettings(SettingsState newSettigsState) {
    emit(newSettigsState);
  }

  void dontShowOnBoardingScreen() {
    const showOnBoardingScreen = false;
    emit(state.copyWith(showOnBoardingScreen: showOnBoardingScreen));
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
  Map<String, Object?>? toJson(SettingsState state) {
    return state.toJson();
  }
}
