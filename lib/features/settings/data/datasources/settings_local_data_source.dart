import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsLocalDataSource {
  static const boxName = 'settings';

  Future<AppSettings> getSettings();

  Future<void> updateThemeMode(AppThemeMode themeMode);

  Future<void> updateCurrency(AppCurrency currency);

  Future<void> updateLanguage(AppLanguage language);

  Future<void> toggleNotifications();

  Future<void> toggleAutoBackup();

  Future<void> resetAllSettings();

  Stream<AppSettings> watchSettings();
}

class HiveSettingsLocalDataSource implements SettingsLocalDataSource {
  const HiveSettingsLocalDataSource(this._box);

  final Box<Map> _box;

  static const String boxName = 'app_settings_box';
  static const String _settingsKey = 'app_settings';

  Future<void> _safePut(Map<String, dynamic> map) async {
    try {
      await _box.put(_settingsKey, map);
    } catch (_) {
      // If writing fails due to stored malformed data, clear the key and try again.
      try {
        await _box.delete(_settingsKey);
      } catch (_) {}
      await _box.put(_settingsKey, map);
    }
  }

  @override
  Future<AppSettings> getSettings() async {
    final data = _box.get(_settingsKey);
    if (data == null) {
      final defaultSettings = AppSettings(
        themeMode: AppThemeMode.system,
        currency: const AppCurrency(code: 'USD', symbol: '\$'),
        language: AppLanguage.english,
        notificationsEnabled: true,
        autoBackupEnabled: false,
      );
      await _safePut(defaultSettings.toJson());
      return defaultSettings;
    }
    return AppSettings.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> updateThemeMode(AppThemeMode themeMode) async {
    final settings = await getSettings();
    final updated = settings.copyWith(themeMode: themeMode);
    await _safePut(updated.toJson());
  }

  @override
  Future<void> updateCurrency(AppCurrency currency) async {
    final settings = await getSettings();
    final updated = settings.copyWith(currency: currency);
    await _safePut(updated.toJson());
  }

  @override
  Future<void> updateLanguage(AppLanguage language) async {
    final settings = await getSettings();
    final updated = settings.copyWith(language: language);
    await _safePut(updated.toJson());
  }

  @override
  Future<void> toggleNotifications() async {
    final settings = await getSettings();
    final updated = settings.copyWith(
      notificationsEnabled: !settings.notificationsEnabled,
    );
    await _safePut(updated.toJson());
  }

  @override
  Future<void> toggleAutoBackup() async {
    final settings = await getSettings();
    final updated = settings.copyWith(
      autoBackupEnabled: !settings.autoBackupEnabled,
    );
    await _safePut(updated.toJson());
  }

  @override
  Future<void> resetAllSettings() async {
    final defaultSettings = AppSettings(
      themeMode: AppThemeMode.system,
      currency: const AppCurrency(code: 'USD', symbol: '\$'),
      language: AppLanguage.english,
      notificationsEnabled: true,
      autoBackupEnabled: false,
    );
    await _safePut(defaultSettings.toJson());
  }

  @override
  Stream<AppSettings> watchSettings() {
    return _box.watch(key: _settingsKey).asyncMap((_) => getSettings());
  }
}
