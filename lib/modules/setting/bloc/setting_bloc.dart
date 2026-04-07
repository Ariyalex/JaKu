import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/application_settings_repository.dart';
import 'package:jaku/modules/setting/bloc/setting_event.dart';
import 'package:jaku/modules/setting/bloc/setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final ApplicationSettingsRepository _repository;
  SettingBloc(this._repository) : super(const SettingState()) {
    on<LoadSetting>(_onLoadSetting);
    on<UpdateSetting>(_onUpdateSetting);
    on<UpdateThemeMode>(_onUpdateThemeMode);
    on<ToggleScheduleView>(_onToggleScheduleView);
  }

  Future<void> _onLoadSetting(
    LoadSetting event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(status: SettingStatus.loading));
    try {
      final setting = _repository.getSetting();
      emit(state.copyWith(setting: setting, status: SettingStatus.success));
    } catch (e) {
      emit(state.copyWith(status: SettingStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateSetting(
    UpdateSetting event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(status: SettingStatus.loading));
    try {
      await _repository.saveSetting(event.setting);
      emit(
        state.copyWith(setting: event.setting, status: SettingStatus.success),
      );
    } catch (e) {
      emit(state.copyWith(status: SettingStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeMode event,
    Emitter<SettingState> emit,
  ) async {
    emit(state.copyWith(status: SettingStatus.loading));
    try {
      await _repository.updateThemeMode(event.themeMode);
      emit(
        state.copyWith(
          setting: state.setting.copyWith(themeMode: event.themeMode),
          status: SettingStatus.success,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SettingStatus.error, message: e.toString()));
    }
  }

  Future<void> _onToggleScheduleView(
    ToggleScheduleView event,
    Emitter<SettingState> emit,
  ) async {
    try {
      final currentView = state.setting.scheduleView;
      print("current view: $currentView");
      await _repository.updateScheduleView(!currentView);
      emit(
        state.copyWith(
          setting: state.setting.copyWith(scheduleView: !currentView),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SettingStatus.error, message: e.toString()));
    }
  }
}
