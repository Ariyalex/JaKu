import 'package:get/get.dart';
import 'package:jaku/domain/models/matkul_schedule.dart';
import 'package:jaku/domain/repositories/matkul_schedule_repository.dart';

class MatkulScheduleService extends GetxService {
  final MatkulScheduleRepository scheduleRepo;
  MatkulScheduleService({required this.scheduleRepo});

  final RxList<MatkulSchedule> matkulSchedules = <MatkulSchedule>[].obs;
  final Rxn<MatkulSchedule> selectedSchedules = Rxn<MatkulSchedule>();
  final RxBool isLoading = false.obs;

  /// save single matkulSchedule
  Future<void> saveSchedule(MatkulSchedule schedule) async {
    isLoading.value = true;
    try {
      await scheduleRepo.addSchedule(schedule);
      final index = matkulSchedules.indexWhere(
        (item) => item.id == schedule.id,
      );
      if (index != -1) {
        matkulSchedules[index] = schedule;
      } else {
        matkulSchedules.add(schedule);
      }
    } catch (e) {
      print("error add schedule(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  ///save list of MatkulSchedule
  Future<void> saveSchedules(List<MatkulSchedule> schedules) async {
    isLoading.value = true;
    try {
      await scheduleRepo.addSchedules(schedules);

      for (var schedule in schedules) {
        final index = matkulSchedules.indexWhere(
          (item) => item.id == schedule.id,
        );
        if (index != -1) {
          matkulSchedules[index] = schedule;
        } else {
          matkulSchedules.add(schedule);
        }
      }
    } catch (e) {
      print("Error add schedules(service)");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// get all matkul schedules
  void loadSchedules() {
    isLoading.value = true;
    try {
      final loadedSchedule = scheduleRepo.getAllSchedule();
      matkulSchedules.assignAll(loadedSchedule);
    } catch (e) {
      print("error load schedules (service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// delete single schedule
  Future<void> deleteSchedule(String id) async {
    isLoading.value = true;
    try {
      await scheduleRepo.deleteSchedule(id);
      matkulSchedules.removeWhere((item) => item.id == id);
    } catch (e) {
      print("error deleting schedule(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// delete all schedule
  Future<void> deleteAllSchedule() async {
    isLoading.value = true;
    try {
      await scheduleRepo.deleteAllSchedule();
      matkulSchedules.clear();
    } catch (e) {
      print("error delete all schedule (service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
