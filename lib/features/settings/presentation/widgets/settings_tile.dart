import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.highlightColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasAction = onTap != null;
    final effectiveTrailing =
        trailing ??
        (hasAction
            ? Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
                size: 20.sp,
              )
            : null);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl.r),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.xl.r),
          splashColor: theme.colorScheme.primary.withAlpha(28),
          highlightColor: theme.colorScheme.primary.withAlpha(18),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg.w,
              vertical: AppSpacing.lg.h,
            ),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: highlightColor ?? theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.lg.r),
                  ),
                  child: Icon(
                    icon,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.lg.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.bodyLarge),
                      if (subtitle != null) ...[
                        SizedBox(height: AppSpacing.xs.h),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (value != null) ...[
                  Text(
                    value!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                if (effectiveTrailing != null) ...[
                  SizedBox(width: AppSpacing.md.w),
                  effectiveTrailing,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
