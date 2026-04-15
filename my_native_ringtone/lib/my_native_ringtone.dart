
import 'my_native_ringtone_platform_interface.dart';

class MyNativeRingtone {
  Future<String?> getPlatformVersion() {
    return MyNativeRingtonePlatform.instance.getPlatformVersion();
  }
}
