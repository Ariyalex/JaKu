import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/matkul_schedule_repository.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final MatkulScheduleRepository _repository;

  ScheduleBloc(this._repository) : super(const ScheduleState()) {
    on<LoadListSchedule>(_onLoadListScheduleByMatkuls);
    on<LoadSchedule>(_onLoadSchedule);
    on<AddListSchedule>(_onAddListSchedule);
    on<AddSchedule>(_onAddSchedule);
    on<UpdateSchedule>(_onUpdateSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
    on<DeleteAllSchedule>(_onDeleteAllSchedule);
  }

  Future<void> _onLoadListScheduleByMatkuls(
    LoadListSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final schedules = _repository.getListScheduleByMatkuls(
        event.matkuls.map((e) => e.id).toList(),
      );
      emit(
        state.copyWith(status: ScheduleStatus.success, schedules: schedules),
      );
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onLoadSchedule(
    LoadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    // If we already have it in list, just set it
    final existing = state.schedules.where((s) => s.id == event.id).firstOrNull;
    if (existing != null) {
      emit(state.copyWith(selectedSchedule: existing));
      return;
    }

    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      final schedule = _repository.getScheduleById(event.id);
      emit(
        state.copyWith(
          status: ScheduleStatus.success,
          selectedSchedule: schedule,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddSchedule(
    AddSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.addSchedule(event.schedule);
      emit(state.copyWith(status: ScheduleStatus.actionSuccess));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddListSchedule(
    AddListSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.addSchedules(event.schedules);
      emit(state.copyWith(status: ScheduleStatus.actionSuccess));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateSchedule(
    UpdateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.updateSchedule(event.schedule);
      emit(state.copyWith(status: ScheduleStatus.actionSuccess));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.deleteSchedule(event.id);
      emit(state.copyWith(status: ScheduleStatus.actionSuccess));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteAllSchedule(
    DeleteAllSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.deleteAllSchedule();
      emit(state.copyWith(status: ScheduleStatus.actionSuccess));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }
}
