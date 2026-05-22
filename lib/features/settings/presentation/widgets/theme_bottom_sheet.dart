import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';

void showThemeBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BuildBottomSheetHeader(title: 'Theme Mode', context: context),
            SizedBox(height: 18.h),
            BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                final selectedMode =
                    state.settings?.themeMode ?? AppThemeMode.system;
                return Column(
                  children: AppThemeMode.values.map((mode) {
                    return _BuildOptionTile(
                      title: _themeLabel(mode),
                      icon: _themeIcon(mode),
                      value: mode,
                      selected: selectedMode == mode,
                      context: context,
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _BuildBottomSheetHeader({
  required String title,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  return Row(
    children: [
      Text(
        title,
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

Widget _BuildOptionTile({
  required String title,
  required IconData icon,
  required AppThemeMode value,
  required bool selected,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 8.h),
    child: ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(
          icon,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24.sp,
        ),
      ),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: selected
          ? Icon(
              Icons.check_circle,
              color: theme.colorScheme.primary,
              size: 22.sp,
            )
          : null,
      onTap: () {
        context.read<SettingsCubit>().updateThemeMode(value);
        Navigator.pop(context);
      },
    ),
  );
}

String _themeLabel(AppThemeMode themeMode) {
  switch (themeMode) {
    case AppThemeMode.light:
      return 'Light';
    case AppThemeMode.dark:
      return 'Dark';
    case AppThemeMode.system:
      return 'System';
  }
}

IconData _themeIcon(AppThemeMode themeMode) {
  switch (themeMode) {
    case AppThemeMode.light:
      return Icons.brightness_high;
    case AppThemeMode.dark:
      return Icons.dark_mode;
    case AppThemeMode.system:
      return Icons.brightness_auto;
  }
}
