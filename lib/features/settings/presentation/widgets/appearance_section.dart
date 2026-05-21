import 'package:flutter/material.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_section.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_tile.dart';

import 'theme_bottom_sheet.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key, 
    required this.settings,
  });

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Appearance',
      children: [
        SettingsTile(
          icon: Icons.brightness_6_outlined,
          title: 'Theme Mode',
          subtitle: 'Choose between light, dark, or system theme',
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
      return 'Light';
    case AppThemeMode.dark:
      return 'Dark';
    case AppThemeMode.system:
      return 'System';
  }
}