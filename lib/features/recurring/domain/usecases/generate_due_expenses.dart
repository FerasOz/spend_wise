import '../../../expenses/domain/entities/expense.dart';
import '../../../expenses/domain/repositories/expense_repository.dart';
import '../entities/recurring_expense.dart';
import '../repositories/recurring_expense_repository.dart';

class GenerateDueExpenses {
  const GenerateDueExpenses(
    this._recurringRepository,
    this._expenseRepository,
  );

  final RecurringExpenseRepository _recurringRepository;
  final ExpenseRepository _expenseRepository;

  Future<int> call() async {
    final recurringExpenses = await _recurringRepository.getRecurringExpenses();
    final today = DateTime.now();
    var generatedCount = 0;

    for (final recurring in recurringExpenses) {
      if (!recurring.isActive) continue;

      var nextDueDate = recurring.nextDueDate;
      while (!_isAfterDay(nextDueDate, today)) {
        await _expenseRepository.addExpense(
          Expense(
            id: '${recurring.id}_${nextDueDate.millisecondsSinceEpoch}',
            title: recurring.title,
            amount: recurring.amount,
            categoryId: recurring.categoryId,
            date: nextDueDate,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        generatedCount++;
        nextDueDate = _nextDate(nextDueDate, recurring.repeatType);
      }

      if (nextDueDate != recurring.nextDueDate) {
        await _recurringRepository.updateRecurringExpense(
          recurring.copyWith(nextDueDate: nextDueDate),
        );
      }
    }

    return generatedCount;
  }

  bool _isAfterDay(DateTime first, DateTime second) {
    final normalizedFirst = DateTime(first.year, first.month, first.day);
    final normalizedSecond = DateTime(second.year, second.month, second.day);
    return normalizedFirst.isAfter(normalizedSecond);
  }

  DateTime _nextDate(DateTime date, RecurringRepeatType repeatType) {
    switch (repeatType) {
      case RecurringRepeatType.weekly:
        return date.add(const Duration(days: 7));
      case RecurringRepeatType.monthly:
        return DateTime(date.year, date.month + 1, date.day);
      case RecurringRepeatType.yearly:
        return DateTime(date.year + 1, date.month, date.day);
    }
  }
}
