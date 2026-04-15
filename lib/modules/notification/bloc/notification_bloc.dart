import 'dart:convert';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:jaku/core/utils/alarm_receiver.dart';
import 'package:timezone/timezone.dart' as tz;
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationBloc() : super(NotificationInitial()) {
    on<NotificationInitialize>(_onInitialize);
    on<ScheduleNotification>(_onSchedule);
    on<CancelNotification>(_onCancel);
    on<SetNotificationPayload>(_onSetPayload);
  }

  Future<void> _onInitialize(
    NotificationInitialize event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final androidPermission = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // get permission on android 13+
      await androidPermission?.requestNotificationsPermission();

      // req permission for exact alarms
      await androidPermission?.requestExactAlarmsPermission();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('notif_icon');

      const InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);

      await flutterLocalNotificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
        onDidReceiveNotificationResponse: (details) async {
          await FlutterRingtonePlayer().stop();
          final String? payloadString = details.payload;
          if (payloadString != null) {
            try {
              final Map<String, dynamic> payload = jsonDecode(payloadString);
              final String? id = payload['id'];
              if (id != null) {
                final portName = 'alarm_port_$id';
                final sendPort = IsolateNameServer.lookupPortByName(portName);
                sendPort?.send('stop_audio');
              }
            } catch (e) {
              final String portName = 'alarm_port_$payloadString';
              final sendPort = IsolateNameServer.lookupPortByName(portName);
              sendPort?.send('stop_audio');
            }
            add(SetNotificationPayload(payloadString));
          }
        },
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onSchedule(
    ScheduleNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          "channel_Id",
          "channel_name",
          importance: Importance.high,
          priority: Priority.high,
        ),
      );
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: event.notifId,
        title: event.title,
        body: event.body,
        scheduledDate: tz.TZDateTime.from(event.scheduledTime, tz.local),
        notificationDetails: platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: event.taskId,
      );
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> _onCancel(
    CancelNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id: event.notifId);
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void _onSetPayload(
    SetNotificationPayload event,
    Emitter<NotificationState> emit,
  ) {
    emit(NotificationLoaded(event.payload));
  }
}
