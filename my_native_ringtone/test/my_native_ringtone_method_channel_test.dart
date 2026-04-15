import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_native_ringtone/my_native_ringtone_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMyNativeRingtone platform = MethodChannelMyNativeRingtone();
  const MethodChannel channel = MethodChannel('my_native_ringtone');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
