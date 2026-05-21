import 'package:flutter/material.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_section.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_tile.dart';
import 'reset_confirmation_dialog.dart';

class DataSection extends StatelessWidget {
  const DataSection({super.key, 
    required this.settings,
  });

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Data & Privacy',
      children: [
        SettingsTile(
          icon: Icons.refresh_outlined,
          title: 'Reset All Settings',
          subtitle: 'Restore all settings to default values',
          onTap: () => showResetConfirmationDialog(context),
        ),
      ],
    );
  }
}