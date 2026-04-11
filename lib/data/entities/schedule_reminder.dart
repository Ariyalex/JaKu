import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jaku/main.dart';

part 'schedule_reminder.g.dart';

@HiveType(typeId: 8)
class ScheduleReminder extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int offsetMinutes;

  @HiveField(2)
  final bool isNotificationOnly;

  @HiveField(3)
  final bool isEnabled;

  const ScheduleReminder({
    required this.id,
    required this.offsetMinutes,
    required this.isNotificationOnly,
    required this.isEnabled,
  });

  @override
  List<Object?> get props => [id, offsetMinutes, isNotificationOnly, isEnabled];

  factory ScheduleReminder.create({
    required int offsetMinutes,
    bool isNotificationOnly = true,
  }) {
    return ScheduleReminder(
      id: uuid.v4(),
      offsetMinutes: offsetMinutes,
      isNotificationOnly: isNotificationOnly,
      isEnabled: true,
    );
  }

  ScheduleReminder copyWith({
    int? offsetMinutes,
    bool? isNotificationOnly,
    bool? isEnabled,
  }) {
    return ScheduleReminder(
      id: id,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      isNotificationOnly: isNotificationOnly ?? this.isNotificationOnly,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}
