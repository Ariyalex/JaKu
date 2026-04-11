import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jaku/core/utils/alarm_helper.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:jaku/data/repositories/application_settings_repository.dart';
import 'package:jaku/data/repositories/matkul_repository.dart';
import 'package:jaku/data/repositories/matkul_schedule_repository.dart';
import 'package:jaku/modules/schedule/bloc/schedule_event.dart';
import 'package:jaku/modules/schedule/bloc/schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final MatkulScheduleRepository _repository;
  final ApplicationSettingsRepository _settingsRepository;
  final MatkulRepository _matkulRepository;

  ScheduleBloc(
    this._repository,
    this._settingsRepository,
    this._matkulRepository,
  ) : super(const ScheduleState()) {
    on<LoadListSchedule>(_onLoadListScheduleByMatkuls);
    on<LoadSchedule>(_onLoadSchedule);
    on<AddListSchedule>(_onAddListSchedule);
    on<AddSchedule>(_onAddSchedule);
    on<UpdateSchedule>(_onUpdateSchedule);
    on<DeleteSchedule>(_onDeleteSchedule);
    on<DeleteSchedules>(_onDeleteSchedules);
    on<RescheduleAllAlarms>(_onRescheduleAllAlarms);
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
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await _repository.addSchedule(event.schedule);

      final matkul = _matkulRepository.getMatkulById(event.schedule.matkulId);
      final setting = _settingsRepository.getSetting();
      await AlarmHelper.scheduleAllForMatkul(matkul, event.schedule, setting);

      emit(
        state.copyWith(
          status: ScheduleStatus.actionSuccess,
          message: "Berhasil menambahkan jadwal!",
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onAddListSchedule(
    AddListSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    emit(state.copyWith(status: ScheduleStatus.loading));
    try {
      await _repository.addSchedules(event.schedules);
      emit(state.copyWith(status: ScheduleStatus.actionSuccess, message: null));
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateSchedule(
    UpdateSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      // Clear old alarm first
      final oldSchedule = _repository.getScheduleById(event.schedule.id);
      await AlarmHelper.cancelAllForMatkul(oldSchedule);

      // Save and set new alarm
      await _repository.updateSchedule(event.schedule);
      final matkul = _matkulRepository.getMatkulById(event.schedule.matkulId);
      final setting = _settingsRepository.getSetting();
      await AlarmHelper.scheduleAllForMatkul(matkul, event.schedule, setting);

      emit(
        state.copyWith(
          status: ScheduleStatus.actionSuccess,
          selectedSchedule: event.schedule,
          message: "Berhasil memperbarui jadwal!",
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteSchedule(
    DeleteSchedule event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      final schedule = _repository.getScheduleById(event.id);
      await AlarmHelper.cancelAllForMatkul(schedule);

      await _repository.deleteSchedule(event.id);

      emit(
        state.copyWith(
          status: ScheduleStatus.actionSuccess,
          message: "Berhasil menghapus jadwal!",
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onDeleteSchedules(
    DeleteSchedules event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      final List<MatkulSchedule> schedules = state.schedules
          .where((schedule) => event.ids.contains(schedule.id))
          .toList();
      AlarmHelper.cancelMultipleSchedules(schedules);

      await _repository.deleteSchedules(event.ids);
      emit(
        state.copyWith(
          status: ScheduleStatus.actionSuccess,
          message: "Berhasil menghapus jadwals!",
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, message: e.toString()));
    }
  }

  Future<void> _onRescheduleAllAlarms(
    RescheduleAllAlarms event,
    Emitter<ScheduleState> emit,
  ) async {
    try {
      // 1. Get all schedules and cancel all alarms to be sure
      final allSchedules = _repository.getAllSchedules();
      await AlarmHelper.cancelMultipleSchedules(allSchedules);

      // 2. Schedule only for active matkuls
      final activeMatkulIds = event.matkuls.map((e) => e.id).toList();
      final activeSchedules = allSchedules
          .where((s) => activeMatkulIds.contains(s.matkulId))
          .toList();

      final setting = _settingsRepository.getSetting();
      await AlarmHelper.scheduleMultipleSchedules(
        event.matkuls,
        activeSchedules,
        setting,
      );
    } catch (e) {
      print("Error in _onRescheduleAllAlarms: $e");
    }
  }
}
