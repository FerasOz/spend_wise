import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

class ExpenseFormIntro extends StatelessWidget {
  const ExpenseFormIntro({
    required this.isEditing,
    super.key,
  });

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: const AlwaysStoppedAnimation(0.9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: const AlwaysStoppedAnimation(0.95),
            child: Text(
              isEditing
                  ? LocaleKeys.expenses_form_intro_editTitle.tr()
                  : LocaleKeys.expenses_form_intro_addTitle.tr(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(height: AppSpacing.md.h),
          FadeTransition(
            opacity: const AlwaysStoppedAnimation(0.9),
            child: Text(
              LocaleKeys.expenses_form_intro_description.tr(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
