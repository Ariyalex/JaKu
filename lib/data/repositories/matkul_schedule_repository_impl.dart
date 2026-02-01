import 'package:jaku/domain/datasources/matkul_schedule_local_datasource.dart';
import 'package:jaku/domain/models/matkul_schedule.dart';
import 'package:jaku/domain/repositories/matkul_schedule_repository.dart';

class MatkulScheduleRepositoryImpl extends MatkulScheduleRepository {
  final MatkulScheduleLocalDatasource localDatasource;
  MatkulScheduleRepositoryImpl({required this.localDatasource});

  @override
  List<MatkulSchedule> getAllSchedule() {
    try {
      return localDatasource.getAllSchedule();
    } catch (e) {
      print("error get all schedule(repo): $e");
      rethrow;
    }
  }

  @override
  MatkulSchedule getScheduleById(String id) {
    try {
      final result = localDatasource.getScheduleById(id);
      if (result == null) throw Exception("Schedule tidak ditemukan");
      return result;
    } catch (e) {
      print("error get schedule(repo): $e");
      rethrow;
    }
  }

  @override
  Future<void> addSchedule(MatkulSchedule schedule) async {
    try {
      await localDatasource.saveSchedule(schedule);
    } catch (e) {
      print("error add schedule(repo): $e");
      rethrow;
    }
  }

  @override
  Future<void> addSchedules(List<MatkulSchedule> schedules) async {
    try {
      await localDatasource.saveSchedules(schedules);
    } catch (e) {
      print("Error add schedules (repo): $e");
      rethrow;
    }
  }

  @override
  Future<void> updateSchedule(MatkulSchedule schedule) async {
    try {
      final getSchedule = localDatasource.getScheduleById(schedule.id);
      if (getSchedule == null) throw Exception("Schedule tidak ditemukan");
      await localDatasource.saveSchedule(schedule);
    } catch (e) {
      print("error update schedule(repo): $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteSchedule(String id) async {
    try {
      final getSchedule = localDatasource.getScheduleById(id);
      if (getSchedule == null) throw Exception("Schedule tidak ditemukan");
      await localDatasource.deleteSchedule(id);
    } catch (e) {
      print("error delete schedule (repo): $e");
      rethrow;
    }
  }

  @override
  Future<void> deleteAllSchedule() async {
    try {
      await localDatasource.deleteAllSchedule();
    } catch (e) {
      print("error delete all schedule(repo): $e");
      rethrow;
    }
  }
}
