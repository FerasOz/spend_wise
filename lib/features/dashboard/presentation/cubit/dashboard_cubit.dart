import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/budgets/domain/entities/budget_progress.dart';
import 'package:spend_wise/features/budgets/domain/usecases/calculate_budget_progress.dart';
import 'package:spend_wise/features/budgets/domain/usecases/get_budgets.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';
import '../../../../core/base/requests_status.dart';
import '../../domain/usecases/get_dashboard_source_data.dart';
import '../../domain/usecases/get_dashboard_summary.dart';
import '../../domain/usecases/get_recent_expenses.dart';
import '../../domain/usecases/get_top_categories.dart';
import '../../domain/usecases/get_weekly_spending.dart';
import 'dashboard_state.dart';
import 'package:spend_wise/features/insights/domain/usecases/generate_insights.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required GetDashboardSourceData getDashboardSourceData,
    required GetDashboardSummary getDashboardSummary,
    required GetWeeklySpending getWeeklySpending,
    required GetRecentExpenses getRecentExpenses,
    required GetTopCategories getTopCategories,
    required GenerateInsights generateInsights,
    required GetBudgets getBudgets,
    required CalculateBudgetProgress calculateBudgetProgress,
  }) : _getDashboardSourceData = getDashboardSourceData,
       _getDashboardSummary = getDashboardSummary,
       _getWeeklySpending = getWeeklySpending,
       _getRecentExpenses = getRecentExpenses,
       _getTopCategories = getTopCategories,
       _generateInsights = generateInsights,
       _getBudgets = getBudgets,
       _calculateBudgetProgress = calculateBudgetProgress,
       super(const DashboardState());

  final GetDashboardSourceData _getDashboardSourceData;
  final GetDashboardSummary _getDashboardSummary;
  final GetWeeklySpending _getWeeklySpending;
  final GetRecentExpenses _getRecentExpenses;
  final GetTopCategories _getTopCategories;
  final GenerateInsights _generateInsights;
  final GetBudgets _getBudgets;
  final CalculateBudgetProgress _calculateBudgetProgress;

  Future<void> loadDashboard() async {
    if (state.status == RequestsStatus.loading) {
      return;
    }

    emit(
      state.copyWith(status: RequestsStatus.loading, clearErrorMessage: true),
    );

    try {
      final sourceData = await _getDashboardSourceData();
      final budgets = await _getBudgets();
      final budgetAlerts = budgets
          .map(_calculateBudgetProgress.call)
          .where((progress) => progress.status != BudgetProgressStatus.safe)
          .toList(growable: false);
      final categoriesMap = <String, Category>{};
      for (final category in sourceData.categories) {
        categoriesMap[category.id] = category;
      }
      emit(
        state.copyWith(
          status: RequestsStatus.success,
          summary: _getDashboardSummary(sourceData),
          insights: _generateInsights(sourceData.expenses, categoriesMap),
          budgetAlerts: budgetAlerts,
          weeklySpending: _getWeeklySpending(sourceData),
          recentExpenses: _getRecentExpenses(sourceData),
          topCategories: _getTopCategories(sourceData),
          categoriesById: {
            for (final category in sourceData.categories) category.id: category,
          },
          clearErrorMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: RequestsStatus.error,
          errorMessage: _mapErrorToMessage(error),
        ),
      );
    }
  }

  String _mapErrorToMessage(Object error) {
    final message = error.toString().trim();
    if (message.isEmpty || message == 'Exception') {
      return LocaleKeys.dashboard_errors_errorLoad.tr();
    }
    return message.startsWith('Exception: ')
        ? message.substring('Exception: '.length)
        : message;
  }
}
