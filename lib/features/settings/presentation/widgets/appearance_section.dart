import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_section.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_tile.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import 'theme_bottom_sheet.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: LocaleKeys.settings_appearance_title.tr(),
      children: [
        SettingsTile(
          icon: Icons.brightness_6_outlined,
          title: LocaleKeys.settings_appearance_themeMode_title.tr(),
          subtitle: LocaleKeys.settings_appearance_themeMode_subtitle.tr(),
          value: _themeModeLabel(settings.themeMode),
          onTap: () => showThemeBottomSheet(context),
        ),
      ],
    );
  }
}

String _themeModeLabel(AppThemeMode themeMode) {
  switch (themeMode) {
    case AppThemeMode.light:
      return LocaleKeys.settings_appearance_themeMode_light.tr();
    case AppThemeMode.dark:
      return LocaleKeys.settings_appearance_themeMode_dark.tr();
    case AppThemeMode.system:
      return LocaleKeys.settings_appearance_themeMode_system.tr();
  }
}
