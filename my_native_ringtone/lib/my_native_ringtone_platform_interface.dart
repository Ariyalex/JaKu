import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'my_native_ringtone_method_channel.dart';

abstract class MyNativeRingtonePlatform extends PlatformInterface {
  /// Constructs a MyNativeRingtonePlatform.
  MyNativeRingtonePlatform() : super(token: _token);

  static final Object _token = Object();

  static MyNativeRingtonePlatform _instance = MethodChannelMyNativeRingtone();

  /// The default instance of [MyNativeRingtonePlatform] to use.
  ///
  /// Defaults to [MethodChannelMyNativeRingtone].
  static MyNativeRingtonePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MyNativeRingtonePlatform] when
  /// they register themselves.
  static set instance(MyNativeRingtonePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
