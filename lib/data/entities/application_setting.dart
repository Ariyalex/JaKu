import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'application_setting.g.dart';

@HiveType(typeId: 7)
class ApplicationSetting extends Equatable {
  @HiveField(0)
  final String themeMode;

  @HiveField(1)
  final bool scheduleView;

  @HiveField(2)
  final String? ringtoneUri;

  @HiveField(3)
  final String? ringtoneTitle;

  const ApplicationSetting({
    required this.themeMode,
    required this.scheduleView,
    this.ringtoneUri,
    this.ringtoneTitle,
  });

  @override
  List<Object?> get props => [
    themeMode,
    scheduleView,
    ringtoneUri,
    ringtoneTitle,
  ];

  ApplicationSetting copyWith({
    String? themeMode,
    bool? scheduleView,
    String? ringtoneUri,
    String? ringtoneTitle,
  }) {
    return ApplicationSetting(
      themeMode: themeMode ?? this.themeMode,
      scheduleView: scheduleView ?? this.scheduleView,
      ringtoneTitle: ringtoneTitle ?? this.ringtoneTitle,
      ringtoneUri: ringtoneUri ?? this.ringtoneUri,
    );
  }
}
