import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource);

  final SettingsLocalDataSource _localDataSource;

  @override
  Future<AppSettings> getSettings() => _localDataSource.getSettings();

  @override
  Future<void> updateThemeMode(AppThemeMode  themeMode) =>
      _localDataSource.updateThemeMode(themeMode);

  @override
  Future<void> updateCurrency(AppCurrency currency) =>
      _localDataSource.updateCurrency(currency);

  @override
  Future<void> updateLanguage(AppLanguage language) =>
      _localDataSource.updateLanguage(language);

  @override
  Future<void> toggleNotifications() => _localDataSource.toggleNotifications();

  @override
  Future<void> toggleAutoBackup() => _localDataSource.toggleAutoBackup();

  @override
  Future<void> resetAllSettings() => _localDataSource.resetAllSettings();

  @override
  Stream<AppSettings> watchSettings() => _localDataSource.watchSettings();
}
