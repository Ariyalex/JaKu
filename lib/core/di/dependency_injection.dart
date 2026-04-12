import 'package:jaku/core/client/dio_client.dart';
import 'package:get_it/get_it.dart';
import 'package:jaku/core/services/alarm_service.dart';
import 'package:jaku/core/services/native_ringtone_service.dart';

final getIt = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    getIt.registerSingleton<DioClient>(DioClient());
    getIt.registerLazySingleton(() => NativeRingtoneService());
    getIt.registerLazySingleton(
      () => AlarmService(getIt<NativeRingtoneService>()),
    );
  }
}
