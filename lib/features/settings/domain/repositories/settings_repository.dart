import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';

import '../entities/app_settings.dart';

abstract class SettingsRepository {
  Future<AppSettings> getSettings();

  Future<void> updateThemeMode(AppThemeMode  themeMode);

  Future<void> updateCurrency(AppCurrency currency);

  Future<void> updateLanguage(AppLanguage language);

  Future<void> toggleNotifications();

  Future<void> toggleAutoBackup();

  Future<void> resetAllSettings();

  Stream<AppSettings> watchSettings();
}
