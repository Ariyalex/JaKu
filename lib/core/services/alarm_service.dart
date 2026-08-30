import 'dart:developer' as dev;

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jaku/core/services/native_ringtone_service.dart';
import 'package:jaku/core/utils/alarm_receiver.dart';
import 'package:jaku/core/utils/time_parser_helper.dart';
import 'package:jaku/data/entities/application_setting.dart';
import 'package:jaku/data/entities/matkul.dart';
import 'package:jaku/data/entities/matkul_schedule.dart';
import 'package:timezone/timezone.dart' as tz;

class AlarmService {
  final NativeRingtoneService _ringtoneService;
  AlarmService(this._ringtoneService);

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleAllForMatkul(
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

  Future<void> _scheduleAlarmWeekly(
    MatkulSchedule schedule,
    String alarmId,
    DateTime firstTriggerTime,
    Matkul matkul,
    ApplicationSetting setting,
  ) async {
    final uniqueId = (schedule.id + alarmId).hashCode & 0x7FFFFFFF;

    String? ringtoneUri = setting.ringtoneUri;

    if (ringtoneUri == null || ringtoneUri.isEmpty) {
      ringtoneUri = await _ringtoneService.getDefaultAlarmUri();
    }

    final Map<String, dynamic> payload = {
      'name': matkul.name,
      'room': schedule.room,
      'startTime': TimeParserHelper.formatTimeOfDay(schedule.startTime),
      'ringtoneUri': ringtoneUri,
    };

    dev.log(
      "Scheduling alarm for ${matkul.name} at $firstTriggerTime with ID $uniqueId",
      name: "AlarmHelper",
    );

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

  Future<void> _scheduleNotification(
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

  Future<void> scheduleMultipleSchedules(
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

  Future<void> cancelAllForMatkul(MatkulSchedule schedule) async {
    for (var alarm in schedule.alarms) {
      final baseId = (schedule.id + alarm.id).hashCode & 0x7FFFFFFF;
      if (alarm.isNotificationOnly) {
        _notificationsPlugin.cancel(id: baseId);
      } else {
        AndroidAlarmManager.cancel(baseId);
      }
    }
  }

  Future<void> cancelMultipleSchedules(List<MatkulSchedule> schedules) async {
    await Future.wait(schedules.map((e) => cancelAllForMatkul(e)));
  }
}
