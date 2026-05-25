import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

void showResetConfirmationDialog(BuildContext context) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      title: Text(
        LocaleKeys.settings_data_reset_dialogTitle.tr(),
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        LocaleKeys.settings_data_reset_dialogMessage.tr(),
        style: theme.textTheme.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            LocaleKeys.common_actions_cancel.tr(),
            style: theme.textTheme.labelLarge,
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
          onPressed: () {
            context.read<SettingsCubit>().resetAllSettings();
            Navigator.pop(context);
          },
          child: Text(LocaleKeys.common_actions_reset.tr()),
        ),
      ],
    ),
  );
}
