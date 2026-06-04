import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

class ExpenseDetailsNoteCard extends StatelessWidget {
  const ExpenseDetailsNoteCard({required this.note, super.key});

  final String note;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocaleKeys.expenses_details_fields_note.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppSpacing.sm.h),
            Text(note, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
