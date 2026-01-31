import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:jaku/domain/value_objects/day.dart';

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
  final DateTime startTime;

  @HiveField(4)
  final DateTime? endTime;

  const MatkulSchedule({
    required this.id,
    required this.matkulId,
    required this.day,
    required this.startTime,
    this.endTime,
  });

  @override
  List<Object?> get props => [id, matkulId, day, startTime, endTime];
}
