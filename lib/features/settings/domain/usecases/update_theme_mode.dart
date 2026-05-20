import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/domain/repositories/settings_repository.dart';

class UpdateThemeMode {
  const UpdateThemeMode(this._repository);

  final SettingsRepository _repository;

  Future<void> call(AppThemeMode themeMode) => _repository.updateThemeMode(themeMode);
}