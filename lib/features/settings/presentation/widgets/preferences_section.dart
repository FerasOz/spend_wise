import 'package:flutter/material.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_section.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_tile.dart';
import 'currency_bottom_sheet.dart';
import 'language_bottom_sheet.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key, 
    required this.settings,
  });

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Preferences',
      children: [
        SettingsTile(
          icon: Icons.currency_exchange_outlined,
          title: 'Currency',
          subtitle: 'Set your default currency for transactions',
          value: '${settings.currency.symbol} ${settings.currency.code}',
          onTap: () => showCurrencyBottomSheet(context),
        ),
        SettingsTile(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: 'Change the app language',
          value: settings.language == AppLanguage.english ? 'English' : 'العربية',
          onTap: () => showLanguageBottomSheet(context),
        ),
      ],
    );
  }
}