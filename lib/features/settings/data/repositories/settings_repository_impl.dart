import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../datasources/settings_remote_data_source.dart';
import '../models/user_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._localDataSource, this._remoteDataSource);

  final SettingsLocalDataSource _localDataSource;
  final SettingsRemoteDataSource _remoteDataSource;

  @override
  Future<AppSettings> getSettings() async {
    final localSettings = await _localDataSource.getSettings();
    final userId = _currentUserId();
    if (userId == null) return localSettings;

    try {
      final remoteSettings = await _remoteDataSource.getUserSettings(userId);
      if (remoteSettings != null) {
        return remoteSettings.toSettings(localSettings);
      }
    } catch (_) {}

    return localSettings;
  }

  @override
  Future<void> updateThemeMode(AppThemeMode themeMode) async {
    await _localDataSource.updateThemeMode(themeMode);
    await _syncRemoteWithCurrentSettings();
  }

  @override
  Future<void> updateCurrency(AppCurrency currency) async {
    await _localDataSource.updateCurrency(currency);
    await _syncRemoteWithCurrentSettings();
  }

  @override
  Future<void> updateLanguage(AppLanguage language) async {
    await _localDataSource.updateLanguage(language);
    await _syncRemoteWithCurrentSettings();
  }

  @override
  Future<void> toggleNotifications() async {
    await _localDataSource.toggleNotifications();
    await _syncRemoteWithCurrentSettings();
  }

  @override
  Future<void> toggleAutoBackup() async {
    await _localDataSource.toggleAutoBackup();
    await _syncRemoteWithCurrentSettings();
  }

  @override
  Future<void> resetAllSettings() async {
    await _localDataSource.resetAllSettings();
    await _syncRemoteWithCurrentSettings();
  }

  @override
  Stream<AppSettings> watchSettings() => _localDataSource.watchSettings();

  Future<void> _syncRemoteWithCurrentSettings() async {
    final userId = _currentUserId();
    if (userId == null) return;

    try {
      final settings = await _localDataSource.getSettings();
      await _remoteDataSource.upsertUserSettings(
        userId,
        UserSettingsModel.fromSettings(settings),
      );
    } catch (_) {}
  }

  String? _currentUserId() {
    try {
      return Supabase.instance.client.auth.currentUser?.id;
    } catch (_) {
      return null;
    }
  }
}
