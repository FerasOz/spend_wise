import 'package:spend_wise/features/settings/domain/repositories/settings_repository.dart';

class ResetAllSettings {
  const ResetAllSettings(this._repository);

  final SettingsRepository _repository;

  Future<void> call() => _repository.resetAllSettings();
}
