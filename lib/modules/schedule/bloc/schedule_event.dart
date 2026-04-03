import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadListSchedule extends ScheduleEvent {
  final List<Matkul> matkuls;
  const LoadListSchedule(this.matkuls);

  @override
  List<Object?> get props => [matkuls];
}

class LoadSchedule extends ScheduleEvent {
  final String id;
  const LoadSchedule(this.id);

  @override
  List<Object?> get props => [id];
}

class AddSchedule extends ScheduleEvent {
  final MatkulSchedule schedule;
  const AddSchedule(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class AddListSchedule extends ScheduleEvent {
  final List<MatkulSchedule> schedules;
  const AddListSchedule(this.schedules);

  @override
  List<Object?> get props => [schedules];
}

class UpdateSchedule extends ScheduleEvent {
  final MatkulSchedule schedule;
  const UpdateSchedule(this.schedule);

  @override
  List<Object?> get props => [schedule];
}

class DeleteSchedule extends ScheduleEvent {
  final String id;
  const DeleteSchedule(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteSchedules extends ScheduleEvent {
  final List<String> ids;
  const DeleteSchedules(this.ids);

  @override
  List<Object?> get props => [ids];
}

class DeleteAllSchedule extends ScheduleEvent {}
