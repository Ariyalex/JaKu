import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/application_setting.dart';

class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadSetting extends SettingEvent {}

class UpdateSetting extends SettingEvent {
  final ApplicationSetting setting;

  const UpdateSetting(this.setting);

  @override
  List<Object?> get props => [setting];
}

class UpdateThemeMode extends SettingEvent {
  final String themeMode;

  const UpdateThemeMode(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class UpdateRingtone extends SettingEvent {
  final String ringtoneUri;
  final String ringtoneTitle;

  const UpdateRingtone(this.ringtoneUri, this.ringtoneTitle);

  @override
  List<Object?> get props => [ringtoneUri, ringtoneTitle];
}

class ToggleScheduleView extends SettingEvent {}
