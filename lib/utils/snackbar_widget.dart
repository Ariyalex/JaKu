import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showAppSnackbar({
  required String title,
  required String message,
  bool isSuccess = true,
  IconData? icon,
  SnackPosition position = SnackPosition.TOP,
  Duration duration = const Duration(seconds: 2),
}) {
  isSuccess
      ? Get.snackbar(
          title,
          message,
          backgroundColor: Colors.green.shade400,
          colorText: Colors.white,
        )
      : Get.snackbar(
          title,
          message,
          backgroundColor: Colors.red.shade400,
          colorText: Colors.white,
        );
}
