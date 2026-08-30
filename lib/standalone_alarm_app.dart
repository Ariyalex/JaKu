import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jaku/core/di/dependency_injection.dart';
import 'package:jaku/core/services/native_ringtone_service.dart';
import 'package:jaku/core/theme/theme.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StandaloneAlarmApp extends StatelessWidget {
  final Map<String, dynamic> payload;

  const StandaloneAlarmApp({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    final nativeRingtoneService = getIt<NativeRingtoneService>();
    final notificationPlugin = FlutterLocalNotificationsPlugin();
    final int notificationId = int.tryParse(payload['id']) ?? 0;

    Future.delayed(const Duration(minutes: 5), () async {
      await nativeRingtoneService.stopRingtone();
      await notificationPlugin.cancel(id: notificationId);
    });

    void stopAlarm(BuildContext context) async {
      await notificationPlugin.cancel(id: notificationId);
      await nativeRingtoneService.stopRingtone();

      // SystemNavigator.pop();
      exit(0);
    }

    final room = payload['room'] as String?;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.alarmClock,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    SizedBox(height: 32),
                    Text(
                      "Waktunya Kelas!",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text(
                            payload['name'] ?? 'Alarm Berbunyi!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          if (room != null && room.isNotEmpty) ...[
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.mapPin, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  payload['room'],
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LucideIcons.clock, size: 16),
                              SizedBox(width: 4),
                              Text(
                                "Pukul ${payload['startTime']}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => stopAlarm(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onError,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Matikan Alarm",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
