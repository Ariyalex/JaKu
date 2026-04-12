import 'package:flutter/services.dart';

class NativeRingtoneService {
  final _channel = MethodChannel('jaku.channel/ringtone');

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
}
