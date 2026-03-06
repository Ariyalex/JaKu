import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {}

class ScheduleListLoading extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleListLoaded extends ScheduleState {
  final List<MatkulSchedule> schedules;
  const ScheduleListLoaded(this.schedules);

  @override
  List<Object?> get props => [schedules];
}

class ScheduleLoaded extends ScheduleState {
  final MatkulSchedule schedule;
  const ScheduleLoaded(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError(this.message);

  @override
  List<Object?> get props => [message];
}
