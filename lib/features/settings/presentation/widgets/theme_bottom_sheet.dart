import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/features/settings/domain/entities/app_settings.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

void showThemeBottomSheet(BuildContext context) {
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
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl.w,
          vertical: AppSpacing.lg.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _SheetHandle(),
            SizedBox(height: AppSpacing.lg.h),
            _buildBottomSheetHeader(
              title: LocaleKeys.settings_appearance_themeMode_title.tr(),
              context: context,
            ),
            SizedBox(height: AppSpacing.lg.h),
            BlocBuilder<SettingsCubit, SettingsState>(
              buildWhen: (previous, current) =>
                  previous.settings?.themeMode != current.settings?.themeMode,
              builder: (context, state) {
                final selectedMode =
                    state.settings?.themeMode ?? AppThemeMode.system;
                return Column(
                  children: AppThemeMode.values.map((mode) {
                    return _buildOptionTile(
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

Widget _buildBottomSheetHeader({
  required String title,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  return Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      IconButton(
        icon: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
        onPressed: () => Navigator.pop(context),
      ),
    ],
  );
}

Widget _buildOptionTile({
  required String title,
  required IconData icon,
  required AppThemeMode value,
  required bool selected,
  required BuildContext context,
}) {
  final theme = Theme.of(context);
  return AnimatedContainer(
    duration: const Duration(milliseconds: 220),
    curve: Curves.easeOutCubic,
    margin: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
    decoration: BoxDecoration(
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg.r),
      border: Border.all(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant,
      ),
    ),
    child: ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.lg.w,
        vertical: AppSpacing.md.h,
      ),
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
      trailing: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: selected
            ? Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 22.sp,
                key: const ValueKey('selected'),
              )
            : SizedBox(key: const ValueKey('unselected')),
      ),
      onTap: () {
        context.read<SettingsCubit>().updateThemeMode(value);
        Navigator.pop(context);
      },
    ),
  );
}

String _themeLabel(AppThemeMode themeMode) {
  return switch (themeMode) {
    AppThemeMode.light => LocaleKeys.settings_appearance_themeMode_light.tr(),
    AppThemeMode.dark => LocaleKeys.settings_appearance_themeMode_dark.tr(),
    AppThemeMode.system => LocaleKeys.settings_appearance_themeMode_system.tr(),
  };
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
