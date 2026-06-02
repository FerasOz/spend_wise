import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/settings/data/datasources/settings_local_data_source.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/get_settings.dart';
import '../../features/settings/domain/usecases/reset_all_settings.dart';
import '../../features/settings/domain/usecases/toggle_auto_backup.dart';
import '../../features/settings/domain/usecases/toggle_notifications.dart';
import '../../features/settings/domain/usecases/update_currency.dart';
import '../../features/settings/domain/usecases/update_language.dart';
import '../../features/settings/domain/usecases/update_theme_mode.dart';
import '../../features/settings/domain/usecases/watch_settings.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';

Future<void> registerSettingsFeature(GetIt sl) async {
  // Settings Local Data Source
  if (!sl.isRegistered<SettingsLocalDataSource>()) {
    sl.registerLazySingleton<SettingsLocalDataSource>(
      () => HiveSettingsLocalDataSource(
        sl<Box<Map>>(instanceName: HiveSettingsLocalDataSource.boxName),
      ),
    );
  }

  // Settings Repository
  if (!sl.isRegistered<SettingsRepository>()) {
    sl.registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(sl<SettingsLocalDataSource>()),
    );
  }

  // Settings Use Cases
  if (!sl.isRegistered<GetSettings>()) {
    sl.registerLazySingleton<GetSettings>(
      () => GetSettings(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateThemeMode>()) {
    sl.registerLazySingleton<UpdateThemeMode>(
      () => UpdateThemeMode(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateCurrency>()) {
    sl.registerLazySingleton<UpdateCurrency>(
      () => UpdateCurrency(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateLanguage>()) {
    sl.registerLazySingleton<UpdateLanguage>(
      () => UpdateLanguage(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<ToggleNotifications>()) {
    sl.registerLazySingleton<ToggleNotifications>(
      () => ToggleNotifications(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<ToggleAutoBackup>()) {
    sl.registerLazySingleton<ToggleAutoBackup>(
      () => ToggleAutoBackup(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<ResetAllSettings>()) {
    sl.registerLazySingleton<ResetAllSettings>(
      () => ResetAllSettings(sl<SettingsRepository>()),
    );
  }

  if (!sl.isRegistered<WatchSettings>()) {
    sl.registerLazySingleton<WatchSettings>(
      () => WatchSettings(sl<SettingsRepository>()),
    );
  }

  // Settings Cubit
  if (!sl.isRegistered<SettingsCubit>()) {
    sl.registerFactory<SettingsCubit>(
      () => SettingsCubit(
        getSettings: sl<GetSettings>(),
        updateThemeMode: sl<UpdateThemeMode>(),
        updateCurrency: sl<UpdateCurrency>(),
        updateLanguage: sl<UpdateLanguage>(),
        toggleNotifications: sl<ToggleNotifications>(),
        toggleAutoBackup: sl<ToggleAutoBackup>(),
        resetAllSettings: sl<ResetAllSettings>(),
        watchSettings: sl<WatchSettings>(),
      ),
    );
  }
}
