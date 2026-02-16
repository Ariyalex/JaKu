import 'package:get/get.dart';
import 'package:jaku/services/matkul_schedule_service.dart';
import 'package:jaku/services/matkul_service.dart';
import 'package:jaku/data/providers/local_matkul_provider.dart';
import 'package:jaku/data/providers/local_matkul_schedule_provider.dart';
import 'package:jaku/data/repositories/matkul_repository.dart';
import 'package:jaku/data/repositories/matkul_schedule_repository.dart';
import 'package:jaku/core/client/hive_client.dart';
import 'package:jaku/domain/datasources/matkul_local_datasource.dart';
import 'package:jaku/domain/datasources/matkul_schedule_local_datasource.dart';
import 'package:jaku/domain/repositories/matkul_repository.dart';
import 'package:jaku/domain/repositories/matkul_schedule_repository.dart';

class DependencyInjection {
  static Future<void> init() async {
    try {
      await _initCoreService();
      await _initDataSource();
      await _initRepositories();
      await _initServices();
    } catch (e) {
      print("error dependency injection: $e");
      rethrow;
    }
  }

  static Future<void> _initCoreService() async {
    try {
      Get.put<hive_client>(hive_client(), permanent: true);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _initDataSource() async {
    try {
      Get.lazyPut<MatkulLocalDatasource>(
        () => MatkulProvider(storageService: Get.find<hive_client>()),
        fenix: true,
      );
      Get.lazyPut<MatkulScheduleLocalDatasource>(
        () => LocalMatkulScheduleProvider(
          storageService: Get.find<hive_client>(),
        ),
        fenix: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _initRepositories() async {
    try {
      Get.lazyPut<MatkulRepository>(
        () => MatkulRepositoryImpl(
          localDatasource: Get.find<MatkulLocalDatasource>(),
        ),
        fenix: true,
      );
      Get.lazyPut<MatkulScheduleRepository>(
        () => MatkulScheduleRepositoryImpl(
          localDatasource: Get.find<MatkulScheduleLocalDatasource>(),
        ),
        fenix: true,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _initServices() async {
    try {
      Get.lazyPut<MatkulService>(
        () => MatkulService(matkulRepo: Get.find<MatkulRepository>()),
        fenix: true,
      );
      Get.lazyPut<MatkulScheduleService>(
        () => MatkulScheduleService(
          scheduleRepo: Get.find<MatkulScheduleRepository>(),
        ),
        fenix: true,
      );
    } catch (e) {
      rethrow;
    }
  }
}
