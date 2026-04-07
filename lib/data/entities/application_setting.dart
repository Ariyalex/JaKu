import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'application_setting.g.dart';

@HiveType(typeId: 7)
class ApplicationSetting extends Equatable {
  @HiveField(0)
  final String themeMode;

  @HiveField(1)
  final bool scheduleView;

  const ApplicationSetting({
    required this.themeMode,
    required this.scheduleView,
  });

  @override
  List<Object?> get props => [themeMode, scheduleView];

  ApplicationSetting copyWith({String? themeMode, bool? scheduleView}) {
    return ApplicationSetting(
      themeMode: themeMode ?? this.themeMode,
      scheduleView: scheduleView ?? this.scheduleView,
    );
  }
}
