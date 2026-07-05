// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingsModel _$UserSettingsModelFromJson(Map<String, dynamic> json) =>
    UserSettingsModel(
      themeMode: json['theme_mode'] as String,
      currencyCode: json['currency_code'] as String,
      language: json['language'] as String,
    );

Map<String, dynamic> _$UserSettingsModelToJson(UserSettingsModel instance) =>
    <String, dynamic>{
      'theme_mode': instance.themeMode,
      'currency_code': instance.currencyCode,
      'language': instance.language,
    };
