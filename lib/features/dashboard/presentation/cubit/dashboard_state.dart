import 'package:spend_wise/core/base/requests_status.dart';
import 'package:spend_wise/features/categories/domain/entities/category.dart';
import 'package:spend_wise/features/dashboard/domain/entities/category_spending.dart';
import 'package:spend_wise/features/dashboard/domain/entities/dashboard_insight.dart';
import 'package:spend_wise/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:spend_wise/features/dashboard/domain/entities/spending_chart_point.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';

class DashboardState {
  const DashboardState({
    this.status = RequestsStatus.initial,
    this.summary,
    this.weeklySpending = const [],
    this.recentExpenses = const [],
    this.topCategories = const [],
    this.insights = const [],
    this.categoriesById = const {},
    this.errorMessage,
  });

  final RequestsStatus status;
  final DashboardSummary? summary;
  final List<SpendingChartPoint> weeklySpending;
  final List<Expense> recentExpenses;
  final List<CategorySpending> topCategories;
  final List<DashboardInsight> insights;
  final Map<String, Category> categoriesById;
  final String? errorMessage;

  DashboardState copyWith({
    RequestsStatus? status,
    DashboardSummary? summary,
    List<SpendingChartPoint>? weeklySpending,
    List<Expense>? recentExpenses,
    List<CategorySpending>? topCategories,
    List<DashboardInsight>? insights,
    Map<String, Category>? categoriesById,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return DashboardState(
      status: status ?? this.status,
      summary: summary ?? this.summary,
      weeklySpending: weeklySpending ?? this.weeklySpending,
      recentExpenses: recentExpenses ?? this.recentExpenses,
      topCategories: topCategories ?? this.topCategories,
      insights: insights ?? this.insights,
      categoriesById: categoriesById ?? this.categoriesById,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get hasExpenses => summary != null && summary!.totalSpending > 0;
}
