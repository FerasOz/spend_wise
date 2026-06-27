import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../categories/presentation/pages/category_list_page.dart';
import '../cubit/dashboard_state.dart';
import 'dashboard_budget_alerts.dart';
import 'dashboard_category_breakdown.dart';
import 'dashboard_insights.dart';
import 'dashboard_recent_expenses.dart';
import 'dashboard_spending_chart.dart';
import 'dashboard_summary_cards.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({required this.state, super.key});

  final DashboardState state;

  @override
  Widget build(BuildContext context) {
    final summary = state.summary!;

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Text(
          LocaleKeys.dashboard_title.tr(),
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          LocaleKeys.dashboard_subTitle.tr(),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: AppSpacing.xxl.h),
        DashboardSummaryCards(summary: summary),
        SizedBox(height: AppSpacing.xxl.h),
        DashboardBudgetAlerts(
          alerts: state.budgetAlerts,
          categoriesById: state.categoriesById,
        ),
        DashboardInsights(insights: state.insights),
        SizedBox(height: AppSpacing.xxl.h),
        DashboardSpendingChart(points: state.weeklySpending),
        SizedBox(height: AppSpacing.xxl.h),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 760) {
              return Column(
                children: [
                  DashboardCategoryBreakdown(
                    categories: state.topCategories,
                    onCategoryTap: (spending) =>
                        CategoryListPage.openCategoryDetailsPage(
                          context,
                          spending.category,
                        ),
                  ),
                  SizedBox(height: AppSpacing.xxl.h),
                  DashboardRecentExpenses(
                    expenses: state.recentExpenses,
                    categoriesById: state.categoriesById,
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: DashboardCategoryBreakdown(
                    categories: state.topCategories,
                    onCategoryTap: (spending) =>
                        CategoryListPage.openCategoryDetailsPage(
                          context,
                          spending.category,
                        ),
                  ),
                ),
                SizedBox(width: AppSpacing.xxl.w),
                Expanded(
                  child: DashboardRecentExpenses(
                    expenses: state.recentExpenses,
                    categoriesById: state.categoriesById,
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: AppSpacing.xxl.h),
      ],
    );
  }
}
