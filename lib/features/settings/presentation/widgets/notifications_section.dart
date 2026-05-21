import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_section.dart';
import 'package:spend_wise/features/settings/presentation/widgets/settings_tile.dart';


class NotificationsSection extends StatelessWidget {
  const NotificationsSection({super.key, 
    required this.settings,
  });

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'Notifications',
      children: [
        SettingsTile(
          icon: Icons.notifications_none_outlined,
          title: 'Notifications',
          subtitle: 'Receive alerts and reminders',
          trailing: Switch(
            value: settings.notificationsEnabled,
            onChanged: (_) => context
                .read<SettingsCubit>()
                .toggleNotifications(),
          ),
        ),
        SettingsTile(
          icon: Icons.cloud_circle_outlined,
          title: 'Auto Backup',
          subtitle: 'Automatically backup your data',
          trailing: Switch(
            value: settings.autoBackupEnabled,
            onChanged: (_) =>
                context.read<SettingsCubit>().toggleAutoBackup(),
          ),
        ),
      ],
    );
  }
}