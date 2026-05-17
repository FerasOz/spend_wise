import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_spacing.dart';

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
            Text('Note', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppSpacing.sm.h),
            Text(note, style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
