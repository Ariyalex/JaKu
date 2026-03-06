import 'package:jaku/core/client/dio_client.dart';
import 'package:jaku/core/client/hive_client.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    getIt.registerSingleton<HiveClient>(HiveClient());
    getIt.registerSingleton<DioClient>(DioClient());
  }
}
