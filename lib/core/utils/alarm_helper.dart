import 'dart:developer' as dev;

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/entities/application_setting.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void alarmCallback(int id, Map<String, dynamic> params) async {
  WidgetsFlutterBinding.ensureInitialized();
  dev.log("Alarm triggered with ID: $id", name: "AlarmHelperCallback");

  final notificationPlugin = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  await notificationPlugin.initialize(
    settings: InitializationSettings(android: androidSettings),
  );

  try {
    const androidDetails = AndroidNotificationDetails(
      'jaku_alarm_channel_v2',
      'Alarm Kelas',
      channelDescription: 'Channel untuk alarm jadwal kuliah',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      setAsGroupSummary: true,
    );

    await notificationPlugin.show(
      id: id,
      title: "Waktunya Kelas!",
      body: "Kelas ${params['name']} akan segera dimulai!",
      notificationDetails: const NotificationDetails(android: androidDetails),
      payload: id.toString(),
    );

    //scheduel next week
    final nextWeek = DateTime.now().add(const Duration(days: 7));

    await AndroidAlarmManager.initialize();

    await AndroidAlarmManager.oneShotAt(
      nextWeek,
      id,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: params,
    );

    dev.log("Notification shown for ID: $id", name: "AlarmHelperCallback");
  } catch (e) {
    dev.log("Error decoding alarm payload: $e", name: "AlarmHelperCallback");
  }
}

class AlarmHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  static Future<void> scheduleAllForMatkul(
    Matkul matkul,
    MatkulSchedule schedule,
    ApplicationSetting setting,
  ) async {
    await cancelAllForMatkul(schedule);
    final now = DateTime.now();

    for (final alarm in schedule.alarms) {
      if (!alarm.isEnabled) continue;

      int daysUntil = (schedule.day.index - (now.weekday - 1)) % 7;
      if (daysUntil < 0) daysUntil += 7;

      DateTime nextClassDate = DateTime(
        now.year,
        now.month,
        now.day + daysUntil,
        schedule.startTime.hour,
        schedule.startTime.minute,
      );
      DateTime triggerTime = nextClassDate.subtract(
        Duration(minutes: alarm.offsetMinutes),
      );

      // Add 5 seconds margin to prevent scheduling a "past" alarm
      if (triggerTime.isBefore(now.add(const Duration(seconds: 5)))) {
        triggerTime = triggerTime.add(const Duration(days: 7));
      }

      final uniqueId = (schedule.id + alarm.id).hashCode & 0x7FFFFFFF;

      if (alarm.isNotificationOnly) {
        await _scheduleNotification(uniqueId, triggerTime, matkul);
      } else {
        await _scheduleAlarmWeekly(
          schedule,
          alarm.id,
          triggerTime,
          matkul,
          setting,
        );
      }
    }
  }

  static Future<void> _scheduleAlarmWeekly(
    MatkulSchedule schedule,
    String alarmId,
    DateTime firstTriggerTime,
    Matkul matkul,
    ApplicationSetting setting,
  ) async {
    final uniqueId = (schedule.id + alarmId).hashCode & 0x7FFFFFFF;

    final Map<String, dynamic> payload = {
      'name': matkul.name,
      'room': schedule.room,
      'startTime': TimeParserHelper.formatTimeOfDay(schedule.startTime),
    };

    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('alarm_payload_$uniqueId', jsonEncode(payload));

    dev.log(
      "Scheduling alarm for ${matkul.name} at $firstTriggerTime with ID $uniqueId",
      name: "AlarmHelper",
    );

    // await AndroidAlarmManager.periodic(
    //   const Duration(days: 7),
    //   uniqueId,
    //   alarmCallback,
    //   startAt: firstTriggerTime,
    //   allowWhileIdle: true,
    //   exact: true,
    //   wakeup: true,
    //   rescheduleOnReboot: true,
    //   params: payload,
    // );

    await AndroidAlarmManager.oneShotAt(
      firstTriggerTime,
      uniqueId,
      alarmCallback,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: payload,
    );
  }

  static Future<void> _scheduleNotification(
    int id,
    DateTime triggerTime,
    Matkul matkul,
  ) async {
    const androidDetails = AndroidNotificationDetails(
      'matkul_channel',
      'Matkul Schedule',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: "Persiapan kelas!",
      body: "Kelas ${matkul.name} akan dimulai",
      scheduledDate: tz.TZDateTime.from(triggerTime, tz.local),
      notificationDetails: const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<void> scheduleMultipleSchedules(
    List<Matkul> matkuls,
    List<MatkulSchedule> schedules,
    ApplicationSetting setting,
  ) async {
    for (var schedule in schedules) {
      final matkul = matkuls.firstWhere(
        (element) => element.id == schedule.matkulId,
        orElse: () => matkuls.first,
      );

      await scheduleAllForMatkul(matkul, schedule, setting);
    }
  }

  static Future<void> cancelAllForMatkul(MatkulSchedule schedule) async {
    for (var alarm in schedule.alarms) {
      final baseId = (schedule.id + alarm.id).hashCode & 0x7FFFFFFF;
      if (alarm.isNotificationOnly) {
        _notificationsPlugin.cancel(id: baseId);
      } else {
        AndroidAlarmManager.cancel(baseId);
      }
    }
  }

  static Future<void> cancelMultipleSchedules(
    List<MatkulSchedule> schedules,
  ) async {
    await Future.wait(schedules.map((e) => cancelAllForMatkul(e)));
  }
}
