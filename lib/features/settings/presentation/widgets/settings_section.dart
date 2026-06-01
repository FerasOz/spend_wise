import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl.h,
        horizontal: AppSpacing.lg.w,
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.sm.h),
            Column(
              children: children
                  .map(
                    (child) => Padding(
                      padding: EdgeInsets.only(bottom: AppSpacing.md.h),
                      child: child,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
