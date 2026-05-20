import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import 'package:spend_wise/features/settings/domain/usecases/get_settings.dart';
import 'package:spend_wise/features/settings/domain/usecases/reset_all_settings.dart';
import 'package:spend_wise/features/settings/domain/usecases/toggle_auto_backup.dart';
import 'package:spend_wise/features/settings/domain/usecases/toggle_notifications.dart';
import 'package:spend_wise/features/settings/domain/usecases/update_currency.dart';
import 'package:spend_wise/features/settings/domain/usecases/update_language.dart';
import 'package:spend_wise/features/settings/domain/usecases/update_theme_mode.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/watch_settings.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({
    required GetSettings getSettings,
    required UpdateThemeMode updateThemeMode,
    required UpdateCurrency updateCurrency,
    required UpdateLanguage updateLanguage,
    required ToggleNotifications toggleNotifications,
    required ToggleAutoBackup toggleAutoBackup,
    required ResetAllSettings resetAllSettings,
    required WatchSettings watchSettings,
  }) : _getSettings = getSettings,
       _updateThemeMode = updateThemeMode,
       _updateCurrency = updateCurrency,
       _updateLanguage = updateLanguage,
       _toggleNotifications = toggleNotifications,
       _toggleAutoBackup = toggleAutoBackup,
       _resetAllSettings = resetAllSettings,
       _watchSettings = watchSettings,
       super(const SettingsState.initial()) {
    loadSettings();
    _settingsSubscription = _watchSettings().listen((s) {
      emit(SettingsState.loaded(s));
    });
  }

  final GetSettings _getSettings;
  final UpdateThemeMode _updateThemeMode;
  final UpdateCurrency _updateCurrency;
  final UpdateLanguage _updateLanguage;
  final ToggleNotifications _toggleNotifications;
  final ToggleAutoBackup _toggleAutoBackup;
  final ResetAllSettings _resetAllSettings;
  final WatchSettings _watchSettings;
  StreamSubscription? _settingsSubscription;

  Future<void> loadSettings() async {
    try {
      final settings = await _getSettings();
      emit(SettingsState.loaded(settings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateThemeMode(AppThemeMode themeMode) async {
    try {
      await _updateThemeMode(themeMode);
      final settings = await _getSettings();
      emit(SettingsState.loaded(settings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateCurrency(AppCurrency currency) async {
    try {
      await _updateCurrency(currency);
      final settings = await _getSettings();
      emit(SettingsState.loaded(settings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> updateLanguage(AppLanguage language) async {
    try {
      await _updateLanguage(language);
      final settings = await _getSettings();
      emit(SettingsState.loaded(settings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> toggleNotifications() async {
    try {
      await _toggleNotifications();
      final settings = await _getSettings();
      emit(SettingsState.loaded(settings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> toggleAutoBackup() async {
    try {
      await _toggleAutoBackup();
      final settings = await _getSettings();
      emit(SettingsState.loaded(settings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  Future<void> resetAllSettings() async {
    try {
      await _resetAllSettings();
      final settings = await _getSettings();
      emit(SettingsState.loaded(settings));
    } catch (e) {
      emit(SettingsState.error(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }
}
