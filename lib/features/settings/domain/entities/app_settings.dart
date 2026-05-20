import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';

enum AppThemeMode { light, dark, system }

enum AppLanguage { english, arabic }

class AppSettings {
  const AppSettings({
    required this.themeMode,
    required this.currency,
    required this.language,
    required this.notificationsEnabled,
    required this.autoBackupEnabled,
  });

  final AppThemeMode themeMode;
  final AppCurrency currency;
  final AppLanguage language;
  final bool notificationsEnabled;
  final bool autoBackupEnabled;

  AppSettings copyWith({
    AppThemeMode? themeMode,
    AppCurrency? currency,
    AppLanguage? language,
    bool? notificationsEnabled,
    bool? autoBackupEnabled,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.name,
      'currency': {'code': currency.code, 'symbol': currency.symbol},
      'language': language.name,
      'notificationsEnabled': notificationsEnabled,
      'autoBackupEnabled': autoBackupEnabled,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      themeMode: AppThemeMode.values.firstWhere(
        (e) => e.name == json['themeMode'],
        orElse: () => AppThemeMode.system,
      ),
      currency: AppCurrency(
        code: json['currency']?['code'] ?? 'USD',
        symbol: json['currency']?['symbol'] ?? '\$',
      ),
      language: AppLanguage.values.firstWhere(
        (e) => e.name == json['language'],
        orElse: () => AppLanguage.english,
      ),
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      autoBackupEnabled: json['autoBackupEnabled'] ?? false,
    );
  }

  factory AppSettings.defaults() {
    return const AppSettings(
      themeMode: AppThemeMode.system,
      currency: AppCurrency(code: 'USD', symbol: '\$'),
      language: AppLanguage.english,
      notificationsEnabled: true,
      autoBackupEnabled: false,
    );
  }

  bool get isDarkMode => themeMode == AppThemeMode.dark;

  bool get isSystemMode => themeMode == AppThemeMode.system;
}
