import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/application_setting.dart';

enum SettingStatus { initial, loading, success, error }

class SettingState extends Equatable {
  final ApplicationSetting setting;
  final SettingStatus status;
  final String? message;

  const SettingState({
    this.setting = const ApplicationSetting(
      themeMode: "System default",
      scheduleView: true,
    ),
    this.status = SettingStatus.initial,
    this.message,
  });

  SettingState copyWith({
    ApplicationSetting? setting,
    SettingStatus? status,
    String? message,
  }) {
    return SettingState(
      setting: setting ?? this.setting,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [setting, status, message];
}
