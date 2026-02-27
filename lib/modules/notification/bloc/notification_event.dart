import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class NotificationInitialize extends NotificationEvent {}

class ScheduleNotification extends NotificationEvent {
  final String title;
  final String body;
  final DateTime scheduledTime;
  final int notifId;
  final String taskId;

  const ScheduleNotification({
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.notifId,
    required this.taskId,
  });

  @override
  List<Object?> get props => [title, body, scheduledTime, notifId, taskId];
}

class CancelNotification extends NotificationEvent {
  final int notifId;

  const CancelNotification(this.notifId);

  @override
  List<Object?> get props => [notifId];
}

class SetNotificationPayload extends NotificationEvent {
  final String payload;

  const SetNotificationPayload(this.payload);

  @override
  List<Object?> get props => [payload];
}
