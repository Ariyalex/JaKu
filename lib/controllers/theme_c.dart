import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeC extends GetxController {
  RxBool isLight = true.obs;

  ThemeMode get themeMode => isLight.value ? ThemeMode.light : ThemeMode.dark;

  void changeTheme() {
    isLight.value = !isLight.value;
  }
}
