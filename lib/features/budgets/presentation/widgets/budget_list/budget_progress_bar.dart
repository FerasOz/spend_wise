import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/budget_progress.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    required this.progress,
    required this.status,
    super.key,
  });

  final double progress;
  final BudgetProgressStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BudgetProgressStatus.safe => AppColors.success,
      BudgetProgressStatus.warning => const Color(0xFFF59E0B),
      BudgetProgressStatus.exceeded => AppColors.danger,
    };

    return ClipRRect(
      borderRadius: BorderRadius.circular(999.r),
      child: LinearProgressIndicator(
        minHeight: 10.h,
        value: progress > 1 ? 1 : progress,
        backgroundColor: color.withAlpha(40),
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
