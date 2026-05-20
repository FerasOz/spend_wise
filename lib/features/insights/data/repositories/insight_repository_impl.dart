import 'package:flutter/material.dart';
import '../../domain/entities/insight_card.dart';
import '../../domain/repositories/insight_repository.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

class InsightRepositoryImpl implements InsightRepository {
  @override
  List<InsightCard> generateInsights(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    if (expenses.isEmpty) return [];

    return [
      getTopCategoryInsight(expenses, categoriesMap),
      getSpendingTrendInsight(expenses),
      getAverageDailyInsight(expenses),
      getHighestSpendingDayInsight(expenses),
      getSpendingStreakInsight(expenses),
      getSmartRecommendationInsight(expenses, categoriesMap),
    ].where((insight) => insight.message.isNotEmpty).toList();
  }

  @override
  InsightCard getTopCategoryInsight(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    if (expenses.isEmpty) {
      return InsightCard(
        id: 'top_category',
        title: 'Top category',
        message: '',
        type: InsightType.topCategory,
        icon: '📊',
        color: Colors.blue.value,
      );
    }

    final categoryTotals = <String, double>{};
    for (final expense in expenses) {
      categoryTotals[expense.categoryId] =
          (categoryTotals[expense.categoryId] ?? 0) + expense.amount;
    }

    final topCategoryId = categoryTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    final topAmount = categoryTotals[topCategoryId]!;
    final category = categoriesMap[topCategoryId];
    final totalSpending = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final percentage = (topAmount / totalSpending * 100).toStringAsFixed(1);

    return InsightCard(
      id: 'top_category',
      title: 'Top category',
      message:
          '${category?.name ?? 'Unknown'} is your top category at $percentage% of spending.',
      type: InsightType.topCategory,
      icon: '📊',
      value: '\$${topAmount.toStringAsFixed(2)}',
      color: category?.color ?? Colors.blue.value,
    );
  }

  @override
  InsightCard getSpendingTrendInsight(List<Expense> expenses) {
    if (expenses.length < 2) {
      return InsightCard(
        id: 'spending_trend',
        title: 'Spending trend',
        message: '',
        type: InsightType.spending_trend,
        icon: '📈',
        color: Colors.green.value,
      );
    }

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final previousMonth = DateTime(now.year, now.month - 1);

    final currentMonthSpending = expenses
        .where(
          (e) =>
              e.date.year == currentMonth.year &&
              e.date.month == currentMonth.month,
        )
        .fold<double>(0, (sum, e) => sum + e.amount);

    final previousMonthSpending = expenses
        .where(
          (e) =>
              e.date.year == previousMonth.year &&
              e.date.month == previousMonth.month,
        )
        .fold<double>(0, (sum, e) => sum + e.amount);

    if (previousMonthSpending == 0) {
      return InsightCard(
        id: 'spending_trend',
        title: 'Spending trend',
        message: '',
        type: InsightType.spending_trend,
        icon: '📈',
        color: Colors.green.value,
      );
    }

    final delta =
        ((currentMonthSpending - previousMonthSpending) /
        previousMonthSpending *
        100);
    final direction = delta >= 0 ? '📈 up' : '📉 down';
    final message =
        'Your spending is $direction ${delta.abs().toStringAsFixed(1)}% compared to last month.';

    return InsightCard(
      id: 'spending_trend',
      title: 'Spending trend',
      message: message,
      type: InsightType.spending_trend,
      icon: '📈',
      value: '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}%',
      color: delta >= 0 ? Colors.orange.value : Colors.green.value,
    );
  }

  @override
  InsightCard getAverageDailyInsight(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return InsightCard(
        id: 'average_daily',
        title: 'Average daily',
        message: '',
        type: InsightType.average_daily,
        icon: '💰',
        color: Colors.purple.value,
      );
    }

    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final daysInMonth =
        monthStart.add(const Duration(days: 32)).month == monthStart.month
        ? 31
        : (monthStart.add(const Duration(days: 31)).month == monthStart.month
              ? 31
              : 30);

    final totalThisMonth = expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .fold<double>(0, (sum, e) => sum + e.amount);

    final avgDaily = totalThisMonth / daysInMonth;

    return InsightCard(
      id: 'average_daily',
      title: 'Average daily',
      message:
          'You\'re spending an average of \$${avgDaily.toStringAsFixed(2)} per day this month.',
      type: InsightType.average_daily,
      icon: '💰',
      value: '\$${avgDaily.toStringAsFixed(2)}',
      color: Colors.purple.value,
    );
  }

  @override
  InsightCard getHighestSpendingDayInsight(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return InsightCard(
        id: 'highest_spending_day',
        title: 'Highest spending day',
        message: '',
        type: InsightType.highest_spending_day,
        icon: '🔥',
        color: Colors.red.value,
      );
    }

    final dailyTotals = <DateTime, double>{};
    for (final expense in expenses) {
      final dayStart = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      dailyTotals[dayStart] = (dailyTotals[dayStart] ?? 0) + expense.amount;
    }

    final highestDay = dailyTotals.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    final dayName = _getDayName(highestDay.key);
    final amount = highestDay.value;

    return InsightCard(
      id: 'highest_spending_day',
      title: 'Highest spending day',
      message:
          'Your highest spending was $dayName with \$${amount.toStringAsFixed(2)}.',
      type: InsightType.highest_spending_day,
      icon: '🔥',
      value: '\$${amount.toStringAsFixed(2)}',
      color: Colors.red.value,
    );
  }

  @override
  InsightCard getSpendingStreakInsight(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return InsightCard(
        id: 'spending_streak',
        title: 'Spending streak',
        message: '',
        type: InsightType.spending_streak,
        icon: '🔥',
        color: Colors.orange.value,
      );
    }

    final now = DateTime.now();
    final sortedExpenses = expenses.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    var streakDays = 0;
    var currentDate = DateTime(now.year, now.month, now.day);

    for (final expense in sortedExpenses) {
      final expenseDate = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      if (expenseDate == currentDate) {
        streakDays++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (expenseDate.isBefore(currentDate)) {
        break;
      }
    }

    return InsightCard(
      id: 'spending_streak',
      title: 'Spending streak',
      message:
          'You have spent on $streakDays consecutive days. Keep the momentum! 🎯',
      type: InsightType.spending_streak,
      icon: '🔥',
      value: '$streakDays days',
      color: Colors.orange.value,
    );
  }

  @override
  InsightCard getSmartRecommendationInsight(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    if (expenses.isEmpty) {
      return InsightCard(
        id: 'smart_recommendation',
        title: 'Smart recommendation',
        message: '',
        type: InsightType.smart_recommendation,
        icon: '💡',
        color: Colors.yellow.value,
      );
    }

    final now = DateTime.now();
    final lastSevenDays = expenses
        .where((e) => e.date.isAfter(now.subtract(const Duration(days: 7))))
        .toList();

    final lastThirtyDays = expenses
        .where((e) => e.date.isAfter(now.subtract(const Duration(days: 30))))
        .toList();

    if (lastThirtyDays.isEmpty) {
      return InsightCard(
        id: 'smart_recommendation',
        title: 'Smart recommendation',
        message: '',
        type: InsightType.smart_recommendation,
        icon: '💡',
        color: Colors.yellow.value,
      );
    }

    final dailyAvg =
        lastThirtyDays.fold<double>(0, (sum, e) => sum + e.amount) / 30;
    final sevenDayAvg =
        lastSevenDays.fold<double>(0, (sum, e) => sum + e.amount) /
        (lastSevenDays.isNotEmpty ? 7 : 1);

    String message;
    if (sevenDayAvg > dailyAvg * 1.2) {
      message =
          'Your spending is ${((sevenDayAvg / dailyAvg - 1) * 100).toStringAsFixed(0)}% higher this week. '
          'Consider reviewing your expenses.';
    } else if (sevenDayAvg < dailyAvg * 0.8) {
      message =
          'Great job! You\'re spending less this week. Keep up the good work! 🎉';
    } else {
      message = 'Your spending is on track with your average. Stay consistent!';
    }

    return InsightCard(
      id: 'smart_recommendation',
      title: 'Smart recommendation',
      message: message,
      type: InsightType.smart_recommendation,
      icon: '💡',
      color: Colors.yellow.value,
    );
  }

  String _getDayName(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[date.weekday - 1]}, ${date.day} ${_getMonthName(date.month)}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
