import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';


void showLanguageBottomSheet(BuildContext context) {

  const languages = [
    {'code': 'en', 'name': 'English', 'nativeName': 'English'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية'},
  ];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) => SafeArea(
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BuildBottomSheetHeader(
              title: 'Language',
              context: context,
            ),
            SizedBox(height: 24.h),
            ...languages.map((language) => _BuildLanguageTile(
                  language: language,
                  context: context,
                )),
          ],
        ),
      ),
    ),
  );
}

Widget _BuildLanguageTile({
  required Map<String, String> language,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  return ListTile(
    leading: Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Icon(
        Icons.language,
        color: theme.colorScheme.onPrimaryContainer,
        size: 24.sp,
      ),
    ),
    title: Text(
      language['name']!,
      style: theme.textTheme.bodyLarge,
    ),
    subtitle: Text(
      language['nativeName']!,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    ),
    onTap: () {
      final languageEnum = language['code'] == 'en'
          ? AppLanguage.english
          : AppLanguage.arabic;
      context.read<SettingsCubit>().updateLanguage(languageEnum);
      Navigator.pop(context);
    },
  );
}

Widget _BuildBottomSheetHeader({
  required String title,
  required BuildContext context,
}) {
  return Row(
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      const Spacer(),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}