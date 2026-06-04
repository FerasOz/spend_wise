// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettingsModel _$AppSettingsModelFromJson(Map<String, dynamic> json) =>
    AppSettingsModel(
      themeMode: json['themeMode'] as String,
      currencyCode: json['currencyCode'] as String,
      language: json['language'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      autoBackupEnabled: json['autoBackupEnabled'] as bool,
    );

Map<String, dynamic> _$AppSettingsModelToJson(AppSettingsModel instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'currencyCode': instance.currencyCode,
      'language': instance.language,
      'notificationsEnabled': instance.notificationsEnabled,
      'autoBackupEnabled': instance.autoBackupEnabled,
    };
