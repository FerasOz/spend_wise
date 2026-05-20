import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/domain/repositories/settings_repository.dart';

class WatchSettings {
  const WatchSettings(this._repository);

  final SettingsRepository _repository;

  Stream<AppSettings> call() => _repository.watchSettings();
}
