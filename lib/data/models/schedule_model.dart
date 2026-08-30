import 'package:jaku/core/utils/time_parser_helper.dart';
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
    required super.alarms,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json, String matkulId) {
    return ScheduleModel(
      id: json["id"],
      matkulId: matkulId,
      day: Day.stringToDay(json["day"]),
      startTime: TimeParserHelper.parseTimeOfDay(json["start_time"]),
      endTime: TimeParserHelper.parseTimeOfDay(json["end_time"]),
      room: json["room"],
      alarms: [],
    );
  }

  MatkulSchedule toEntity() {
    return MatkulSchedule(
      id: id,
      matkulId: matkulId,
      day: day,
      startTime: startTime,
      endTime: endTime,
      room: room,
      alarms: alarms,
    );
  }
}
