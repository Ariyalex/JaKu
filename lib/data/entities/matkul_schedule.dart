import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  const MatkulSchedule({
    required this.id,
    required this.matkulId,
    required this.day,
    required this.startTime,
    this.endTime,
    this.room,
  });

  @override
  List<Object?> get props => [id, matkulId, day, startTime, endTime, room];

  factory MatkulSchedule.create({
    required String matkulId,
    required Day day,
    required TimeOfDay startTime,
    TimeOfDay? endTime,
    String? room,
  }) {
    return MatkulSchedule(
      id: uuid.v4(),
      matkulId: matkulId,
      day: day,
      startTime: startTime,
      endTime: endTime,
      room: room,
    );
  }
}
