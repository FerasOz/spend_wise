import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:spend_wise/core/constants/currencies.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_section.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_tile.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import 'currency_bottom_sheet.dart';
import 'language_bottom_sheet.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({required this.settings, super.key});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: LocaleKeys.settings_preferences_title.tr(),
      children: [
        SettingsTile(
          icon: Icons.currency_exchange_outlined,
          title: LocaleKeys.settings_preferences_currency_title.tr(),
          subtitle: LocaleKeys.settings_preferences_currency_subtitle.tr(),
          value: currencyLabel(settings.currency),
          onTap: () => showCurrencyBottomSheet(context),
        ),
        SettingsTile(
          icon: Icons.language_outlined,
          title: LocaleKeys.settings_preferences_language_title.tr(),
          subtitle: LocaleKeys.settings_preferences_language_subtitle.tr(),
          value: settings.language == AppLanguage.english
              ? LocaleKeys.settings_languages_english.tr()
              : LocaleKeys.settings_languages_arabic.tr(),
          onTap: () => showLanguageBottomSheet(context),
        ),
      ],
    );
  }
}
