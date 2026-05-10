import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/requests_status.dart';
import '../../domain/usecases/get_dashboard_source_data.dart';
import '../../domain/usecases/get_dashboard_insights.dart';
import '../../domain/usecases/get_dashboard_summary.dart';
import '../../domain/usecases/get_recent_expenses.dart';
import '../../domain/usecases/get_top_categories.dart';
import '../../domain/usecases/get_weekly_spending.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    required GetDashboardSourceData getDashboardSourceData,
    required GetDashboardInsights getDashboardInsights,
    required GetDashboardSummary getDashboardSummary,
    required GetWeeklySpending getWeeklySpending,
    required GetRecentExpenses getRecentExpenses,
    required GetTopCategories getTopCategories,
  }) : _getDashboardSourceData = getDashboardSourceData,
       _getDashboardInsights = getDashboardInsights,
       _getDashboardSummary = getDashboardSummary,
       _getWeeklySpending = getWeeklySpending,
       _getRecentExpenses = getRecentExpenses,
       _getTopCategories = getTopCategories,
       super(const DashboardState());

  final GetDashboardSourceData _getDashboardSourceData;
  final GetDashboardInsights _getDashboardInsights;
  final GetDashboardSummary _getDashboardSummary;
  final GetWeeklySpending _getWeeklySpending;
  final GetRecentExpenses _getRecentExpenses;
  final GetTopCategories _getTopCategories;

  Future<void> loadDashboard() async {
    emit(state.copyWith(status: RequestsStatus.loading, clearErrorMessage: true));

    try {
      final sourceData = await _getDashboardSourceData();
      emit(
        state.copyWith(
          status: RequestsStatus.success,
          summary: _getDashboardSummary(sourceData),
          insights: _getDashboardInsights(sourceData),
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
      return 'Failed to load dashboard.';
    }
    return message.startsWith('Exception: ')
        ? message.substring('Exception: '.length)
        : message;
  }
}
