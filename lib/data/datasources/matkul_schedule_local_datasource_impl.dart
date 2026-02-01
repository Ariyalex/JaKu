import 'package:hive/hive.dart';
import 'package:jaku/data/services/storage_service.dart';
import 'package:jaku/domain/datasources/matkul_schedule_local_datasource.dart';
import 'package:jaku/domain/models/matkul_schedule.dart';

class MatkulScheduleLocalDatasourceImpl extends MatkulScheduleLocalDatasource {
  final StorageService storageService;
  MatkulScheduleLocalDatasourceImpl({required this.storageService});

  Box<MatkulSchedule> get _box => storageService.matkulScheduleBox;

  @override
  List<MatkulSchedule> getAllSchedule() {
    try {
      return _box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  MatkulSchedule? getScheduleById(String id) {
    try {
      return _box.get(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveSchedule(MatkulSchedule schedule) async {
    try {
      await _box.put(schedule.id, schedule);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveSchedules(List<MatkulSchedule> schedules) async {
    try {
      for (var schedule in schedules) {
        await _box.put(schedule.id, schedule);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(MatkulSchedule schedule) async {
    try {
      await _box.put(schedule.id, schedule);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAllSchedule() async {
    try {
      await _box.clear();
    } catch (e) {
      rethrow;
    }
  }
}
