import 'package:flutter/material.dart';

class ThemeModeUtils {
  static ThemeMode stringToThemeMode(String mode) {
    switch (mode) {
      case "System default":
        return ThemeMode.system;
      case "Light":
        return ThemeMode.light;
      case "Dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static String themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return "System default";
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
    }
  }
}
