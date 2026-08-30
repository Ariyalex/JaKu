import 'package:flutter/services.dart';

class NativeRingtoneService {
  final _channel = MethodChannel('jaku.channel/ringtone');
  final _ringtoneChannel = MethodChannel('my_native_ringtone');

  Future<String?> getDefaultAlarmUri() async {
    try {
      return await _channel.invokeMethod<String?>('getDefaultAlarmUri');
    } catch (e) {
      return null;
    }
  }

  Future<String> getRingtoneTitle(String uri) async {
    try {
      final title = await _channel.invokeMethod<String>('getRingtoneTitle', {
        'uri': uri,
      });
      return title ?? "Unknown Alarm";
    } catch (e) {
      return "Unknown Alarm";
    }
  }

  Future<String?> openRingtonePicker() async {
    try {
      return await _channel.invokeMethod<String>('openRingtonePicker');
    } catch (e) {
      return null;
    }
  }

  Future<void> playRingtone(String? uri) async {
    try {
      await _ringtoneChannel.invokeMethod('playRingtone', {'uri': uri});
    } on PlatformException catch (e) {
      print("🐛 [NativeRingtoneDart] Error playing: ${e.message}");
    }
  }

  Future<void> stopRingtone() async {
    try {
      await _ringtoneChannel.invokeMethod('stopRingtone');
    } on PlatformException catch (e) {
      print("🐛 [NativeRingtoneDart] Error stopping: ${e.message}");
    }
  }
}
