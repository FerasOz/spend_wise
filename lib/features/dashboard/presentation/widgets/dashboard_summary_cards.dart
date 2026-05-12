import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

import '../../domain/entities/dashboard_summary.dart';
import 'dashboard_section_card.dart';

class DashboardSummaryCards extends StatelessWidget {
  const DashboardSummaryCards({required this.summary, super.key});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCardData(
        title: 'Total spending',
        value: '\$${summary.totalSpending.toStringAsFixed(2)}',
        subtitle: 'Lifetime',
        icon: Icons.account_balance_wallet_outlined,
      ),
      _SummaryCardData(
        title: 'This month',
        value: '\$${summary.monthlySpending.toStringAsFixed(2)}',
        subtitle: 'Current month',
        icon: Icons.calendar_month_outlined,
      ),
      _SummaryCardData(
        title: 'This week',
        value: '\$${summary.weeklySpending.toStringAsFixed(2)}',
        subtitle: 'Current week',
        icon: Icons.date_range_outlined,
      ),
      _SummaryCardData(
        title: 'Average daily',
        value: '\$${summary.averageDailySpending.toStringAsFixed(2)}',
        subtitle: '${summary.transactionCount} transactions tracked',
        icon: Icons.trending_up_outlined,
      ),
    ];

    return DashboardSectionCard(
      title: 'Overview',
      subtitle: 'A fast read on your spending rhythm',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 720 ? 4 : 2;

          return GridView.builder(
            itemCount: cards.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: AppSpacing.md.w,
              mainAxisSpacing: AppSpacing.md.h,
              mainAxisExtent: constraints.maxWidth > 720 ? 150.h : 164.h,
            ),
            itemBuilder: (context, index) =>
                _DashboardSummaryCard(data: cards[index]),
          );
        },
      ),
    );
  }
}

class _DashboardSummaryCard extends StatelessWidget {
  const _DashboardSummaryCard({required this.data});

  final _SummaryCardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.all(AppSpacing.xl.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withAlpha(18),
            theme.colorScheme.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xxl.r),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(72),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data.icon, color: theme.colorScheme.primary),
          const Spacer(),
          Text(data.title, style: theme.textTheme.bodyMedium),
          SizedBox(height: AppSpacing.sm.h),
          Text(
            data.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (data.subtitle != null) ...[
            SizedBox(height: AppSpacing.xs.h),
            Text(
              data.subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SummaryCardData {
  const _SummaryCardData({
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
}
