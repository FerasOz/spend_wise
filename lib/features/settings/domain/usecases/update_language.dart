import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/domain/repositories/settings_repository.dart';

class UpdateLanguage {
  const UpdateLanguage(this._repository);

  final SettingsRepository _repository;

  Future<void> call(AppLanguage language) => _repository.updateLanguage(language);
}