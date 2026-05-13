import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spend_wise/core/theme/app_spacing.dart';

import '../../../categories/presentation/pages/category_list_page.dart';
import '../cubit/dashboard_state.dart';
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
          'Your money at a glance',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        SizedBox(height: AppSpacing.sm.h),
        Text(
          'A clear look at your spending pace, category trends, and latest activity.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: AppSpacing.xxl.h),
        DashboardSummaryCards(summary: summary),
        SizedBox(height: AppSpacing.xxl.h),
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
                  SizedBox(height: 24.h),
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
                SizedBox(width: 24.w),
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
        SizedBox(height: 24.h),
      ],
    );
  }
}
