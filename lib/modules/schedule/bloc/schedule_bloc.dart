import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/data/repositories/matkul_schedule_repository.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final MatkulScheduleRepository _repository;

  ScheduleBloc(this._repository) : super(ScheduleInitial()) {
    on<LoadListSchedule>(_onLoadListSchedule);
    on<LoadSchedule>(_onLoadSchedule);
    on<AddListSchedule>(_onAddListSchedule);
    on<AddSchedule>(_onAddSchedule);
    on<UpdateSchedule>(_onUpdateSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
    on<DeleteAllSchedule>(_onDeleteAllSchedule);
  }

  Future<void> _onLoadListSchedule(
    LoadListSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleListLoading());
    try {
      final schedules = _repository.getAllSchedule();
      emit(ScheduleListLoaded(schedules));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onLoadSchedule(
    LoadSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(ScheduleLoading());
    try {
      final schedule = _repository.getScheduleById(event.id);
      emit(ScheduleLoaded(schedule));
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onAddSchedule(
    AddSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.addSchedule(event.schedule);
      add(LoadListSchedule());
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onAddListSchedule(
    AddListSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.addSchedules(event.schedules);
      add(LoadListSchedule());
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onUpdateSchedule(
    UpdateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.updateSchedule(event.schedule);
      add(LoadListSchedule());
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onDeleteSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.deleteSchedule(event.id);
      add(LoadListSchedule());
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }

  Future<void> _onDeleteAllSchedule(
    DeleteAllSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      await _repository.deleteAllSchedule();
      add(LoadListSchedule());
    } catch (e) {
      emit(ScheduleError(e.toString()));
    }
  }
}
