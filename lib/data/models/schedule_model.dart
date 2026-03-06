import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/value_objects/day.dart';

class ScheduleModel extends MatkulSchedule {
  const ScheduleModel({
    required super.id,
    required super.matkulId,
    required super.day,
    required super.startTime,
    super.endTime,
    super.room,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json, String matkulId) {
    return ScheduleModel(
      id: json["id"],
      matkulId: matkulId,
      day: Day.stringToDay(json["day"]),
      startTime: DateTime.parse(json["start_time"]),
      endTime: DateTime.tryParse(json["end_time"]),
      room: json["room"],
    );
  }
}
