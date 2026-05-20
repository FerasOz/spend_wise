import 'package:spend_wise/features/settings/domain/repositories/settings_repository.dart';

class ToggleNotifications {
  const ToggleNotifications(this._repository);

  final SettingsRepository _repository;

  Future<void> call() => _repository.toggleNotifications();
}