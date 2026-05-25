import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_section.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_tile.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key, required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: LocaleKeys.settings_notifications_title.tr(),
      children: [
        SettingsTile(
          icon: Icons.notifications_none_outlined,
          title: LocaleKeys.settings_notifications_title.tr(),
          subtitle: LocaleKeys.settings_notifications_push_subtitle.tr(),
          trailing: Switch(
            value: settings.notificationsEnabled,
            onChanged: (_) =>
                context.read<SettingsCubit>().toggleNotifications(),
          ),
        ),
        SettingsTile(
          icon: Icons.cloud_circle_outlined,
          title: LocaleKeys.settings_notifications_backup_title.tr(),
          subtitle: LocaleKeys.settings_notifications_backup_subtitle.tr(),
          trailing: Switch(
            value: settings.autoBackupEnabled,
            onChanged: (_) => context.read<SettingsCubit>().toggleAutoBackup(),
          ),
        ),
      ],
    );
  }
}
