import 'package:flutter_test/flutter_test.dart';
import 'package:my_native_ringtone/my_native_ringtone.dart';
import 'package:my_native_ringtone/my_native_ringtone_platform_interface.dart';
import 'package:my_native_ringtone/my_native_ringtone_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMyNativeRingtonePlatform
    with MockPlatformInterfaceMixin
    implements MyNativeRingtonePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final MyNativeRingtonePlatform initialPlatform = MyNativeRingtonePlatform.instance;

  test('$MethodChannelMyNativeRingtone is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMyNativeRingtone>());
  });

  test('getPlatformVersion', () async {
    MyNativeRingtone myNativeRingtonePlugin = MyNativeRingtone();
    MockMyNativeRingtonePlatform fakePlatform = MockMyNativeRingtonePlatform();
    MyNativeRingtonePlatform.instance = fakePlatform;

    expect(await myNativeRingtonePlugin.getPlatformVersion(), '42');
  });
}
