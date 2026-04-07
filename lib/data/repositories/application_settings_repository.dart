import 'package:jaku/data/entities/application_setting.dart';
import 'package:jaku/data/providers/local_settings_provider.dart';

class ApplicationSettingsRepository {
  final LocalSettingsProvider _provider;
  const ApplicationSettingsRepository(this._provider);

  ApplicationSetting getSetting() {
    try {
      return _provider.getSetting();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSetting(ApplicationSetting setting) async {
    try {
      await _provider.saveSetting(setting);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateThemeMode(String newThemeMode) async {
    try {
      await _provider.updateThemeMode(newThemeMode);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateScheduleView(bool newScheduleView) async {
    try {
      await _provider.updateScheduleView(newScheduleView);
    } catch (e) {
      rethrow;
    }
  }
}
