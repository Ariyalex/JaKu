import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeC extends GetxController {
  RxBool isLight = true.obs;

  ThemeMode get themeMode => isLight.value ? ThemeMode.light : ThemeMode.dark;

  void changeTheme() {
    isLight.value = !isLight.value;
    Hive.box('settings').put('isLight', isLight.value);
  }

  void initTheme() {
    final box = Hive.box('settings');
    if (box.containsKey('isLight')) {
      isLight.value = box.get('isLight') as bool;
    } else {
      isLight.value = true;
      box.put('isLight', true);
    }
  }
}
