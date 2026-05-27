import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_radius.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../domain/entities/dashboard_summary.dart';
import 'dashboard_section_card.dart';
import '../../../../core/widgets/currency_text.dart';

class DashboardSummaryCards extends StatelessWidget {
  const DashboardSummaryCards({required this.summary, super.key});

  final DashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final cards = [
      _SummaryCardData(
        title: LocaleKeys.dashboard_overview_totalSpending.tr(),
        amount: summary.totalSpending,
        subtitle: LocaleKeys.dashboard_overview_lifetime.tr(),
        icon: Icons.account_balance_wallet_outlined,
      ),
      _SummaryCardData(
        title: LocaleKeys.dashboard_overview_spentThisMonth.tr(),
        amount: summary.monthlySpending,
        subtitle: LocaleKeys.dashboard_overview_monthLabel.tr(),
        icon: Icons.calendar_month_outlined,
      ),
      _SummaryCardData(
        title: LocaleKeys.dashboard_overview_thisWeek.tr(),
        amount: summary.weeklySpending,
        subtitle: LocaleKeys.dashboard_overview_CurrentWeek.tr(),
        icon: Icons.date_range_outlined,
      ),
      _SummaryCardData(
        title: LocaleKeys.dashboard_overview_averageDaily.tr(),
        amount: summary.averageDailySpending,
        subtitle:
            '${summary.transactionCount} ${LocaleKeys.dashboard_overview_transactionsTracked.tr()}',
        icon: Icons.trending_up_outlined,
      ),
    ];

    return DashboardSectionCard(
      title: LocaleKeys.dashboard_overview_title.tr(),
      subtitle: LocaleKeys.dashboard_overview_subTitle.tr(),
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
          CurrencyText(
            amount: data.amount,
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
    required this.amount,
    required this.icon,
    this.subtitle,
  });

  final String title;
  final double amount;
  final String? subtitle;
  final IconData icon;
}
