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
      child: Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _BuildBottomSheetHeader(
              title: 'Theme Mode',
              context: context,
            ),
            SizedBox(height: 24.h),
            ..._BuildThemeOptions(context),
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

List<Widget> _BuildThemeOptions(BuildContext context) {
  return [
    _BuildOptionTile(
      title: 'Light',
      icon: Icons.brightness_high,
      value: AppThemeMode.light,
      context: context,
    ),
    _BuildOptionTile(
      title: 'Dark',
      icon: Icons.brightness_low,
      value: AppThemeMode.dark,
      context: context,
    ),
    _BuildOptionTile(
      title: 'System',
      icon: Icons.brightness_auto,
      value: AppThemeMode.system,
      context: context,
    ),
  ];
}

Widget _BuildOptionTile({
  required String title,
  required IconData icon,
  required AppThemeMode value,
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
        icon,
        color: theme.colorScheme.onPrimaryContainer,
        size: 24.sp,
      ),
    ),
    title: Text(title, style: theme.textTheme.bodyLarge),
    onTap: () {
      context.read<SettingsCubit>().updateThemeMode(value);
      Navigator.pop(context);
    },
  );
}