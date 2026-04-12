import 'dart:developer' as dev;
import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

@pragma('vm:entry-point')
void alarmCallback(int id, Map<String, dynamic> params) async {
  WidgetsFlutterBinding.ensureInitialized();
  dev.log("Alarm triggered with ID: $id", name: "AlarmHelperCallback");

  final String portName = 'alarm_port_$id';

  IsolateNameServer.removePortNameMapping(portName);

  final recievePort = ReceivePort();
  IsolateNameServer.registerPortWithName(recievePort.sendPort, portName);

  recievePort.listen((message) async {
    if (message == 'stop_audio') {
      await FlutterRingtonePlayer().stop();

      final notificationPlugin = FlutterLocalNotificationsPlugin();
      await notificationPlugin.cancel(id: id);

      recievePort.close();
      IsolateNameServer.removePortNameMapping(portName);
    }
  });

  final notificationPlugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('notif_icon');

  await notificationPlugin.initialize(
    settings: InitializationSettings(android: androidSettings),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    onDidReceiveNotificationResponse: (details) async {
      await FlutterRingtonePlayer().stop();
    },
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

    await notificationPlugin.show(
      id: id,
      title: "Waktunya Kelas!",
      body: "Kelas ${params['name']} akan segera dimulai!",
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: id.toString(),
    );

    final String? customUri = params['ringtoneUri'];

    if (customUri != null && customUri.isNotEmpty) {
      await FlutterRingtonePlayer().play(
        android: AndroidSounds.alarm,
        fromFile: customUri,
        looping: true,
        asAlarm: true,
      );
    } else {
      await FlutterRingtonePlayer().playAlarm(looping: true);
    }

    //scheduel next week
    final nextWeek = DateTime.now().add(const Duration(minutes: 6));

    // await AndroidAlarmManager.initialize();

    await AndroidAlarmManager.oneShotAt(
      nextWeek,
      id,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: params,
    );

    Future.delayed(const Duration(minutes: 5), () async {
      FlutterRingtonePlayer().stop();
      recievePort.close();
      IsolateNameServer.removePortNameMapping(portName);
      await notificationPlugin.cancel(id: id);
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
    final String? idString = response.payload;

    if (idString != null) {
      final String portName = 'alarm_port_$idString';
      final SendPort? sendPort = IsolateNameServer.lookupPortByName(portName);

      if (sendPort != null) {
        sendPort.send('stop_audio');
      }
    }
  }
}
