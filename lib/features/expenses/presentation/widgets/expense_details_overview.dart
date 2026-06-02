import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../features/categories/domain/entities/category.dart';
import '../../../../features/categories/presentation/utils/category_display_name.dart';
import '../../domain/entities/expense.dart';

class ExpenseDetailsOverview extends StatelessWidget {
  const ExpenseDetailsOverview({
    required this.expense,
    required this.category,
    super.key,
  });

  final Expense expense;
  final Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.expenses_details_fields_title.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          expense.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppSpacing.xxl.h),
        Text(
          LocaleKeys.expenses_details_fields_category.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          category.localizedName,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
