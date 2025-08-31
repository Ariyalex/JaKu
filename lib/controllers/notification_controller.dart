import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationController extends GetxController {
  RxString payload = "".obs;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<void> scheduleNotification(
    String title,
    String body,
    DateTime scheduledTime,
    int notifId,
    String taskId,
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
        notifId,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: taskId,
      );
    } catch (error) {
      print("error scheduling notification: $error");
    }
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    //init the plugin
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final androidPermission = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    //get permission on android 13+
    androidPermission?.requestNotificationsPermission();

    //req permission for exact alarms
    androidPermission?.requestExactAlarmsPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notif_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}
