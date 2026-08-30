import 'dart:convert';
import 'dart:developer' as dev;

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jaku/core/services/native_ringtone_service.dart';

@pragma('vm:entry-point')
void alarmCallback(int id, Map<String, dynamic> params) async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidAlarmManager.initialize();
  dev.log("Alarm triggered with ID: $id", name: "AlarmHelperCallback");

  final notificationPlugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('notif_icon');

  await notificationPlugin.initialize(
    settings: InitializationSettings(android: androidSettings),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  try {
    const androidDetails = AndroidNotificationDetails(
      'jaku_alarm_channel_v3',
      'Alarm Kelas',
      channelDescription: 'Channel untuk alarm jadwal kuliah',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      autoCancel: false,
      playSound: false,
      ongoing: true,
      visibility: NotificationVisibility.public,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      category: AndroidNotificationCategory.alarm,
      setAsGroupSummary: true,
      actions: [
        AndroidNotificationAction(
          'stop_alarm',
          'Matikan Alarm',
          cancelNotification: true,
        ),
      ],
    );

    final payloadMap = {
      'id': id.toString(),
      'name': params['name'] ?? "Unknown",
      'room': params['room'] ?? "Unknown",
      'startTime': params['startTime'] ?? "--:--",
    };

    await notificationPlugin.show(
      id: id,
      title: "Waktunya Kelas!",
      body: "Kelas ${params['name']} akan segera dimulai!",
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: jsonEncode(payloadMap),
    );

    final String? customUri = params['ringtoneUri'];

    final nativeRingtoneService = NativeRingtoneService();

    await nativeRingtoneService.playRingtone(customUri);

    //scheduel next week
    final nextWeek = DateTime.now().add(const Duration(days: 7));

    await AndroidAlarmManager.oneShotAt(
      nextWeek,
      id,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: params,
    );

    await Future.delayed(const Duration(minutes: 5), () async {
      nativeRingtoneService.stopRingtone();
      notificationPlugin.cancel(id: id);
    });

    dev.log("Notification shown for ID: $id", name: "AlarmHelperCallback");
  } catch (e) {
    dev.log("Error decoding alarm payload: $e", name: "AlarmHelperCallback");
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (response.actionId == 'stop_alarm' || response.actionId == null) {
    await NativeRingtoneService().stopRingtone();
  }
}
