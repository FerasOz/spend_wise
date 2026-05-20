import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/core/widgets/responsive_page_content.dart';
import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import '../../domain/entities/app_settings.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (!state.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = state.settings!;

          return ResponsivePageContent(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
              child: Column(
                children: [
                  SettingsSection(
                    title: 'Appearance',
                    children: [_buildThemeModeTile(context, settings)],
                  ),
                  SettingsSection(
                    title: 'Preferences',
                    children: [
                      _buildCurrencyTile(context, settings),
                      _buildLanguageTile(context, settings),
                    ],
                  ),
                  SettingsSection(
                    title: 'Notifications & Backup',
                    children: [
                      _buildNotificationsTile(context, settings),
                      _buildAutoBackupTile(context, settings),
                    ],
                  ),
                  SettingsSection(
                    title: 'Data',
                    children: [_buildResetTile(context)],
                  ),
                  SizedBox(height: 16.h),
                  _buildAboutSection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildThemeModeTile(BuildContext context, AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.dark_mode_outlined),
      title: const Text('Theme'),
      subtitle: Text(""),
      onTap: () => _showThemeBottomSheet(context),
    );
  }

  Widget _buildCurrencyTile(BuildContext context, AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.currency_exchange),
      title: const Text('Currency'),
      subtitle: Text(""),
      onTap: () => _showCurrencyBottomSheet(context),
    );
  }

  Widget _buildLanguageTile(BuildContext context, AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.language),
      title: const Text('Language'),
      subtitle: Text(""),
      onTap: () => _showLanguageBottomSheet(context),
    );
  }

  Widget _buildNotificationsTile(BuildContext context, AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.notifications_outlined),
      title: const Text('Notifications'),
      trailing: Switch(
        value: settings.notificationsEnabled,
        onChanged: (_) => context.read<SettingsCubit>().toggleNotifications(),
      ),
    );
  }

  Widget _buildAutoBackupTile(BuildContext context, AppSettings settings) {
    return ListTile(
      leading: const Icon(Icons.backup),
      title: const Text('Auto Backup'),
      trailing: Switch(
        value: settings.autoBackupEnabled,
        onChanged: (_) => context.read<SettingsCubit>().toggleAutoBackup(),
      ),
    );
  }

  Widget _buildResetTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.refresh, color: Colors.red),
      title: const Text('Reset All Data'),
      subtitle: const Text('This action cannot be undone'),
      onTap: () => _showResetConfirmationDialog(context),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About Spend Wise', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          Text('Version 1.0.0', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }

  void _showThemeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: ['Light', 'Dark', 'System'].map((mode) {
          return ListTile(
            title: Text(mode),
            onTap: () {
              AppThemeMode themeMode;
              switch (mode) {
                case 'Light':
                  themeMode = AppThemeMode.light;
                  break;
                case 'Dark':
                  themeMode = AppThemeMode.dark;
                  break;
                case 'System':
                  themeMode = AppThemeMode.system;
                  break;
                default:
                  themeMode = AppThemeMode.system;
              }
              context.read<SettingsCubit>().updateThemeMode(themeMode);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  AppCurrency _getCurrencyByCode(String code) {
    // This is a simplified implementation - in a real app, you'd have a proper currency repository
    switch (code) {
      case 'USD':
        return const AppCurrency(code: 'USD', symbol: '\$');
      case 'EUR':
        return const AppCurrency(code: 'EUR', symbol: '€');
      case 'GBP':
        return const AppCurrency(code: 'GBP', symbol: '£');
      case 'JPY':
        return const AppCurrency(code: 'JPY', symbol: '¥');
      case 'INR':
        return const AppCurrency(code: 'INR', symbol: '₹');
      case 'AED':
        return const AppCurrency(code: 'AED', symbol: 'د.إ');
      case 'CAD':
        return const AppCurrency(code: 'CAD', symbol: 'C\$');
      case 'AUD':
        return const AppCurrency(code: 'AUD', symbol: 'A\$');
      default:
        return const AppCurrency(code: 'USD', symbol: '\$');
    }
  }

  void _showCurrencyBottomSheet(BuildContext context) {
    const currencies = ['USD', 'EUR', 'GBP', 'JPY', 'INR', 'AED', 'CAD', 'AUD'];
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: currencies.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(currencies[index]),
            onTap: () {
              final currency = _getCurrencyByCode(currencies[index]);
              context.read<SettingsCubit>().updateCurrency(currency);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    const languages = [('English', 'en'), ('Arabic', 'ar')];
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: languages.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(languages[index].$1),
            onTap: () {
              AppLanguage language;
              switch (languages[index].$1) {
                case 'English':
                  language = AppLanguage.english;
                  break;
                case 'Arabic':
                  language = AppLanguage.arabic;
                  break;
                default:
                  language = AppLanguage.english;
              }
              context.read<SettingsCubit>().updateLanguage(language);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  void _showResetConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Settings?'),
        content: const Text('This will reset all settings to defaults.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<SettingsCubit>().resetAllSettings();
              Navigator.pop(context);
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
