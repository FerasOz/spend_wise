import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import 'package:spend_wise/features/settings/domain/repositories/settings_repository.dart';

class UpdateCurrency {
  const UpdateCurrency(this._repository);

  final SettingsRepository _repository;

  Future<void> call(AppCurrency currency) => _repository.updateCurrency(currency);
}