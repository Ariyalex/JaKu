import 'package:hive/hive.dart';
import 'package:jaku/data/models/matkul_schedule.dart';

class LocalMatkulScheduleProvider {
  Box<MatkulSchedule> get _box => Hive.box<MatkulSchedule>("scheduleBox");

  List<MatkulSchedule> getAllSchedule() {
    try {
      return _box.values.toList();
    } catch (e) {
      rethrow;
    }
  }

  MatkulSchedule? getScheduleById(String id) {
    try {
      return _box.get(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSchedule(MatkulSchedule schedule) async {
    try {
      await _box.put(schedule.id, schedule);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSchedules(List<MatkulSchedule> schedules) async {
    try {
      for (var schedule in schedules) {
        await _box.put(schedule.id, schedule);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateSchedule(MatkulSchedule schedule) async {
    try {
      await _box.put(schedule.id, schedule);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _box.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllSchedule() async {
    try {
      await _box.clear();
    } catch (e) {
      rethrow;
    }
  }
}
