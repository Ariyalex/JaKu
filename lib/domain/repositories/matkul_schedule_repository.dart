import 'package:jaku/domain/models/matkul_schedule.dart';

abstract class MatkulScheduleRepository {
  List<MatkulSchedule> getAllSchedule();
  MatkulSchedule getScheduleById(String id);
  Future<void> addSchedule(MatkulSchedule schedule);
  Future<void> addSchedules(List<MatkulSchedule> schedules);
  Future<void> updateSchedule(MatkulSchedule schedule);
  Future<void> deleteSchedule(String id);
  Future<void> deleteAllSchedule();
}
