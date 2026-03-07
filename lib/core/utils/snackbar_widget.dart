import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showAppSnackbar({
  required String title,
  required String message,
  bool isSuccess = true,
  IconData? icon,
  Duration duration = const Duration(seconds: 2),
}) {
  toastification.show(
    title: Text(title),
    description: Text(message),
    autoCloseDuration: duration,
    type: isSuccess ? ToastificationType.success : ToastificationType.error,
    style: ToastificationStyle.flatColored,
    alignment: Alignment.topCenter,
    icon: icon != null ? Icon(icon) : null,
  );
}
