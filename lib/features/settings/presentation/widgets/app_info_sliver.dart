import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/constants/currencies.dart';
import 'package:spend_wise/features/settings/domain/entities/app_currency.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class AppInfoSliver extends StatelessWidget {
  const AppInfoSliver({required this.settings, super.key});

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
              _InfoHeader(),
              SizedBox(height: 20.h),
              Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  _InfoChip(label: _themeModeLabel(settings.themeMode)),
                  _InfoChip(label: _currencyLabel(settings.currency)),
                  _InfoChip(label: _languageLabel(settings.language)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          child: Icon(
            Icons.settings,
            color: theme.colorScheme.onPrimary,
            size: 28.sp,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.settings_hero_title.tr(),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                LocaleKeys.settings_hero_subtitle.tr(),
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label, style: Theme.of(context).textTheme.labelSmall),
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
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

String _languageLabel(AppLanguage language) {
  return language == AppLanguage.english
      ? LocaleKeys.settings_languages_englishNative.tr()
      : LocaleKeys.settings_languages_arabicNative.tr();
}

String _currencyLabel(AppCurrency currency) {
  return switch (currency.code.toUpperCase()) {
    'USD' => LocaleKeys.currency_names_USD.tr(),
    'EUR' => LocaleKeys.currency_names_EUR.tr(),
    'ILS' => LocaleKeys.currency_names_ILS.tr(),
    'JOD' => LocaleKeys.currency_names_JOD.tr(),
    'SAR' => LocaleKeys.currency_names_SAR.tr(),
    'GBP' => LocaleKeys.currency_names_GBP.tr(),
    _ => currencyLabel(currency),
  };
}
