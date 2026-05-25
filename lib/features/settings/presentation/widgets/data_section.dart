import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_section.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_tile.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'reset_confirmation_dialog.dart';

class DataSection extends StatelessWidget {
  const DataSection({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: LocaleKeys.settings_data_title.tr(),
      children: [
        SettingsTile(
          icon: Icons.refresh_outlined,
          title: LocaleKeys.settings_data_reset_title.tr(),
          subtitle: LocaleKeys.settings_data_reset_subtitle.tr(),
          onTap: () => showResetConfirmationDialog(context),
        ),
      ],
    );
  }
}
