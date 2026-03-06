import 'package:get/get.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/repositories/matkul_repository.dart';

class MatkulService extends GetxService {
  final MatkulRepository matkulRepo;
  MatkulService({required this.matkulRepo});

  final RxList<Matkul> matkuls = <Matkul>[].obs;
  final RxBool isLoading = false.obs;

  /// save single matkulSchedule
  Future<void> saveMatkul(Matkul matkul) async {
    isLoading.value = true;
    try {
      await matkulRepo.addMatkul(matkul);
      final index = matkuls.indexWhere((item) => item.id == matkul.id);
      if (index != -1) {
        matkuls[index] = matkul;
      } else {
        matkuls.add(matkul);
      }
    } catch (e) {
      print("error add matkul(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  ///save list of MatkulSchedule
  Future<void> saveMatkuls(List<Matkul> listMatkul) async {
    isLoading.value = true;
    try {
      await matkulRepo.addMatkuls(listMatkul);

      for (var matkul in listMatkul) {
        final index = matkuls.indexWhere((item) => item.id == matkul.id);
        if (index != -1) {
          matkuls[index] = matkul;
        } else {
          matkuls.add(matkul);
        }
      }
    } catch (e) {
      print("Error add matkuls(service)");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// get all matkul schedules
  void loadMatkuls() {
    isLoading.value = true;
    try {
      final loadedSchedule = matkulRepo.getAllMatkul();
      matkuls.assignAll(loadedSchedule);
    } catch (e) {
      print("error load schedules (service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// delete single schedule
  Future<void> deleteMatkul(String id) async {
    isLoading.value = true;
    try {
      await matkulRepo.deleteMatkul(id);
      matkuls.removeWhere((item) => item.id == id);
    } catch (e) {
      print("error deleting schedule(service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// delete all schedule
  Future<void> deleteAllMatkul() async {
    isLoading.value = true;
    try {
      await matkulRepo.deleteAllMatkul();
      matkuls.clear();
    } catch (e) {
      print("error delete all schedule (service): $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadMatkuls();
  }
}
