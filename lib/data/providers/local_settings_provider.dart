import 'package:hive/hive.dart';
import 'package:jaku/data/entities/application_setting.dart';

class LocalSettingsProvider {
  static const String _settingsKey = "app_settings";

  Box<ApplicationSetting> get _box =>
      Hive.box<ApplicationSetting>('settingBox');

  ApplicationSetting getSetting() {
    try {
      return _box.get(
        _settingsKey,
        defaultValue: const ApplicationSetting(
          themeMode: "System default",
          scheduleView: true,
        ),
      )!;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSetting(ApplicationSetting setting) async {
    try {
      await _box.put(_settingsKey, setting);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateThemeMode(String newThemeMode) async {
    try {
      final currentSettings = getSetting();
      final updateSettings = currentSettings.copyWith(themeMode: newThemeMode);
      await saveSetting(updateSettings);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateScheduleView(bool newScheduleView) async {
    try {
      final currentSettings = getSetting();
      final updateSettings = currentSettings.copyWith(
        scheduleView: newScheduleView,
      );
      await saveSetting(updateSettings);
    } catch (e) {
      rethrow;
    }
  }
}
