import 'package:jaku/data/providers/local_matkul_schedule_provider.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';

class MatkulScheduleRepository {
  final LocalMatkulScheduleProvider localProvider;
  MatkulScheduleRepository(this.localProvider);

  List<MatkulSchedule> getAllSchedule() {
    try {
      return localProvider.getAllSchedule();
    } catch (e) {
      print("error get all schedule(repo): $e");
      rethrow;
    }
  }

  MatkulSchedule getScheduleById(String id) {
    try {
      final result = localProvider.getScheduleById(id);
      if (result == null) throw Exception("Schedule tidak ditemukan");
      return result;
    } catch (e) {
      print("error get schedule(repo): $e");
      rethrow;
    }
  }

  Future<void> addSchedule(MatkulSchedule schedule) async {
    try {
      await localProvider.saveSchedule(schedule);
    } catch (e) {
      print("error add schedule(repo): $e");
      rethrow;
    }
  }

  Future<void> addSchedules(List<MatkulSchedule> schedules) async {
    try {
      await localProvider.saveSchedules(schedules);
    } catch (e) {
      print("Error add schedules (repo): $e");
      rethrow;
    }
  }

  Future<void> updateSchedule(MatkulSchedule schedule) async {
    try {
      final getSchedule = localProvider.getScheduleById(schedule.id);
      if (getSchedule == null) throw Exception("Schedule tidak ditemukan");
      await localProvider.saveSchedule(schedule);
    } catch (e) {
      print("error update schedule(repo): $e");
      rethrow;
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      final getSchedule = localProvider.getScheduleById(id);
      if (getSchedule == null) throw Exception("Schedule tidak ditemukan");
      await localProvider.deleteSchedule(id);
    } catch (e) {
      print("error delete schedule (repo): $e");
      rethrow;
    }
  }

  Future<void> deleteAllSchedule() async {
    try {
      await localProvider.deleteAllSchedule();
    } catch (e) {
      print("error delete all schedule(repo): $e");
      rethrow;
    }
  }
}
