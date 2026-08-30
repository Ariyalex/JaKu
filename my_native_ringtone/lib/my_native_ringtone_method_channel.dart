import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'my_native_ringtone_platform_interface.dart';

/// An implementation of [MyNativeRingtonePlatform] that uses method channels.
class MethodChannelMyNativeRingtone extends MyNativeRingtonePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('my_native_ringtone');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
