import 'package:equatable/equatable.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';

enum ScheduleStatus { initial, loading, success, error }

class ScheduleState extends Equatable {
  final List<MatkulSchedule> schedules;
  final MatkulSchedule? selectedSchedule;
  final ScheduleStatus status;
  final String? message;

  const ScheduleState({
    this.schedules = const [],
    this.selectedSchedule,
    this.status = ScheduleStatus.initial,
    this.message,
  });

  ScheduleState copyWith({
    List<MatkulSchedule>? schedules,
    MatkulSchedule? selectedSchedule,
    ScheduleStatus? status,
    String? message,
    bool clearSelected = false,
  }) {
    return ScheduleState(
      schedules: schedules ?? this.schedules,
      selectedSchedule: clearSelected ? null : (selectedSchedule ?? this.selectedSchedule),
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [schedules, selectedSchedule, status, message];
}
