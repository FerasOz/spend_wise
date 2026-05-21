import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';

class AppInfoSliver extends StatelessWidget {
  const AppInfoSliver({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 20.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  _BuildChip(label: _themeModeLabel(settings.themeMode), context: context),
                  _BuildChip(label: _currencyLabel(settings.currency), context: context),
                  _BuildChip(label: _languageLabel(settings.language), context: context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(Icons.settings, color: theme.colorScheme.onPrimary, size: 28.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personalize Spend Wise',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Update your preferences in one place',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuildChip extends StatelessWidget {
  const _BuildChip({required this.label, required this.context});

  final String label;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(label, style: theme.textTheme.labelSmall),
      backgroundColor: theme.colorScheme.surfaceVariant,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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

String _languageLabel(AppLanguage language) {
  switch (language) {
    case AppLanguage.english:
      return 'English';
    case AppLanguage.arabic:
      return 'العربية';
  }
}

String _currencyLabel(AppCurrency currency) {
  return '${currency.symbol} ${currency.code}';
}