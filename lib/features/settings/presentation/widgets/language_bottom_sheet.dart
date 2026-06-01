import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/app_settings.dart';
import '../cubit/settings_cubit.dart';

void showLanguageBottomSheet(BuildContext context) {
  const languages = [
    _LanguageOption(code: 'en', language: AppLanguage.english),
    _LanguageOption(code: 'ar', language: AppLanguage.arabic),
  ];

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.xxl.r),
      ),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xxl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            SizedBox(height: AppSpacing.lg.h),
            _LanguageHeader(),
            SizedBox(height: AppSpacing.lg.h),
            ...languages.map((option) => _LanguageTile(option: option)),
          ],
        ),
      ),
    ),
  );
}

class _LanguageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          LocaleKeys.settings_preferences_language_title.tr(),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.option});

  final _LanguageOption option;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLanguage = context.select(
      (SettingsCubit cubit) =>
          cubit.state.settings?.language ?? AppLanguage.english,
    );
    final isSelected = selectedLanguage == option.language;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.lg.r),
        ),
        child: Icon(
          Icons.language,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24.sp,
        ),
      ),
      title: Text(option.label.tr(), style: theme.textTheme.bodyLarge),
      subtitle: Text(option.nativeLabel.tr(), style: theme.textTheme.bodySmall),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: () async {
        await context.read<SettingsCubit>().updateLanguage(option.language);
        if (context.mounted) Navigator.pop(context);
      },
    );
  }
}

class _LanguageOption {
  const _LanguageOption({required this.code, required this.language});

  final String code;
  final AppLanguage language;

  String get label => code == 'en'
      ? LocaleKeys.settings_languages_english
      : LocaleKeys.settings_languages_arabic;

  String get nativeLabel => code == 'en'
      ? LocaleKeys.settings_languages_englishNative
      : LocaleKeys.settings_languages_arabicNative;
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 52.w,
        height: 5.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(32),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}
