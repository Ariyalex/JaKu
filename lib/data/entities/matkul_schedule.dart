import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:jaku/data/entities/schedule_reminder.dart';
import 'package:jaku/data/value_objects/day.dart';
import 'package:jaku/main.dart';

part 'matkul_schedule.g.dart';

@HiveType(typeId: 0)
class MatkulSchedule extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String matkulId;

  @HiveField(2)
  final Day day;

  @HiveField(3)
  final TimeOfDay startTime;

  @HiveField(4)
  final TimeOfDay? endTime;

  @HiveField(5)
  final String? room;

  @HiveField(6, defaultValue: [])
  final List<ScheduleReminder> alarms;

  const MatkulSchedule({
    required this.id,
    required this.matkulId,
    required this.day,
    required this.startTime,
    this.endTime,
    this.room,
    required this.alarms,
  });

  @override
  List<Object?> get props => [
    id,
    matkulId,
    day,
    startTime,
    endTime,
    room,
    alarms,
  ];

  factory MatkulSchedule.create({
    required String matkulId,
    required Day day,
    required TimeOfDay startTime,
    TimeOfDay? endTime,
    String? room,
    List<ScheduleReminder>? alarms,
  }) {
    return MatkulSchedule(
      id: uuid.v4(),
      matkulId: matkulId,
      day: day,
      startTime: startTime,
      endTime: endTime,
      room: room,
      alarms: alarms ?? [],
    );
  }

  MatkulSchedule copyWith({
    String? matkulId,
    Day? day,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? room,
    List<ScheduleReminder>? alarms,
  }) {
    return MatkulSchedule(
      id: id,
      matkulId: matkulId ?? this.matkulId,
      day: day ?? this.day,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      alarms: alarms ?? this.alarms,
    );
  }
}
