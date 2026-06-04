import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/app_settings.dart';
import '../../../../core/constants/currencies.dart';

part 'app_settings_model.g.dart';

@JsonSerializable()
class AppSettingsModel {
  const AppSettingsModel({
    required this.themeMode,
    required this.currencyCode,
    required this.language,
    required this.notificationsEnabled,
    required this.autoBackupEnabled,
  });

  final String themeMode;
  final String currencyCode;
  final String language;
  final bool notificationsEnabled;
  final bool autoBackupEnabled;

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsModelToJson(this);

  factory AppSettingsModel.fromEntity(AppSettings entity) {
    return AppSettingsModel(
      themeMode: entity.themeMode.name,
      currencyCode: entity.currency.code,
      language: entity.language.name,
      notificationsEnabled: entity.notificationsEnabled,
      autoBackupEnabled: entity.autoBackupEnabled,
    );
  }

  AppSettings toEntity() {
    return AppSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (e) => e.name == themeMode,
        orElse: () => AppThemeMode.system,
      ),
      currency: currencyByCode(currencyCode),
      language: AppLanguage.values.firstWhere(
        (e) => e.name == language,
        orElse: () => AppLanguage.english,
      ),
      notificationsEnabled: notificationsEnabled,
      autoBackupEnabled: autoBackupEnabled,
    );
  }
}
