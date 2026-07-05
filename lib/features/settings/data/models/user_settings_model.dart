import 'package:json_annotation/json_annotation.dart';
import 'package:spend_wise/core/constants/currencies.dart';
import '../../domain/entities/app_settings.dart';

part 'user_settings_model.g.dart';

@JsonSerializable()
class UserSettingsModel {
  @JsonKey(name: 'theme_mode')
  final String themeMode;

  @JsonKey(name: 'currency_code')
  final String currencyCode;

  final String language;

  const UserSettingsModel({
    required this.themeMode,
    required this.currencyCode,
    required this.language,
  });

  factory UserSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsModelToJson(this);

  factory UserSettingsModel.fromSettings(AppSettings settings) {
    return UserSettingsModel(
      themeMode: settings.themeMode.name,
      currencyCode: settings.currency.code,
      language: settings.language.name,
    );
  }

  AppSettings toSettings(AppSettings currentSettings) {
    return currentSettings.copyWith(
      themeMode: AppThemeMode.values.firstWhere(
        (e) => e.name == themeMode,
        orElse: () => AppThemeMode.system,
      ),
      currency: currencyByCode(currencyCode),
      language: AppLanguage.values.firstWhere(
        (e) => e.name == language,
        orElse: () => AppLanguage.english,
      ),
    );
  }
}
