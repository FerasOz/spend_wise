import 'package:flutter_test/flutter_test.dart';
import 'package:spend_wise/features/budgets/domain/entities/budget.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense.dart';
import 'package:spend_wise/features/expenses/domain/entities/expense_filter.dart';
import 'package:spend_wise/features/expenses/domain/usecases/get_visible_expenses.dart';

void main() {
  late GetVisibleExpenses useCase;

  setUp(() {
    useCase = const GetVisibleExpenses();
  });

  final tExpenses = [
    Expense(
      id: '1',
      title: 'Coffee',
      amount: 4.5,
      categoryId: 'cat_food',
      date: DateTime(2026, 6, 10),
    ),
    Expense(
      id: '2',
      title: 'Groceries',
      amount: 85.0,
      categoryId: 'cat_food',
      date: DateTime(2026, 6, 15),
    ),
    Expense(
      id: '3',
      title: 'Bus Ticket',
      amount: 2.5,
      categoryId: 'cat_transport',
      date: DateTime(2026, 6, 12),
    ),
    Expense(
      id: '4',
      title: 'Gym Membership',
      amount: 40.0,
      categoryId: 'cat_health',
      date: DateTime(2026, 6, 1),
    ),
    Expense(
      id: '5',
      title: 'Coffee Beans',
      amount: 12.0,
      categoryId: 'cat_food',
      date: DateTime(2026, 6, 20),
    ),
  ];

  group('GetVisibleExpenses', () {
    test('should return all expenses with default filter', () {
      const filter = ExpenseFilter();
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, tExpenses.length);
    });

    test('should sort by newest first by default', () {
      const filter = ExpenseFilter();
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.first.id, '5'); // June 20
      expect(result.last.id, '4'); // June 1
    });

    test('should sort by oldest first', () {
      const filter = ExpenseFilter(sortOption: ExpenseSortOption.oldest);
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.first.id, '4'); // June 1
      expect(result.last.id, '5'); // June 20
    });

    test('should sort by highest amount', () {
      const filter = ExpenseFilter(sortOption: ExpenseSortOption.highestAmount);
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.first.id, '2'); // 85.0
      expect(result.last.id, '3'); // 2.5
    });

    test('should sort by lowest amount', () {
      const filter = ExpenseFilter(sortOption: ExpenseSortOption.lowestAmount);
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.first.id, '3'); // 2.5
      expect(result.last.id, '2'); // 85.0
    });

    test('should filter by search query (case-insensitive)', () {
      const filter = ExpenseFilter(searchQuery: 'coffee');
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 2);
      expect(result.every((e) => e.title.toLowerCase().contains('coffee')), true);
    });

    test('should filter by category', () {
      const filter = ExpenseFilter(categoryId: 'cat_food');
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 3);
      expect(result.every((e) => e.categoryId == 'cat_food'), true);
    });

    test('should filter by start date', () {
      final filter = ExpenseFilter(startDate: DateTime(2026, 6, 12));
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 3); // June 12, 15, 20
      expect(result.every((e) => !e.date.isBefore(DateTime(2026, 6, 12))), true);
    });

    test('should filter by end date', () {
      final filter = ExpenseFilter(endDate: DateTime(2026, 6, 12));
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 3); // June 1, 10, 12
      expect(result.every((e) => !e.date.isAfter(DateTime(2026, 6, 12))), true);
    });

    test('should filter by date range', () {
      final filter = ExpenseFilter(
        startDate: DateTime(2026, 6, 10),
        endDate: DateTime(2026, 6, 15),
      );
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 3); // June 10, 12, 15
    });

    test('should filter by minimum amount', () {
      const filter = ExpenseFilter(minAmount: 10.0);
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 3); // 85.0, 40.0, 12.0
      expect(result.every((e) => e.amount >= 10.0), true);
    });

    test('should filter by maximum amount', () {
      const filter = ExpenseFilter(maxAmount: 10.0);
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 2); // 4.5, 2.5
      expect(result.every((e) => e.amount <= 10.0), true);
    });

    test('should filter by amount range', () {
      const filter = ExpenseFilter(minAmount: 5.0, maxAmount: 50.0);
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 2); // 12.0, 40.0
      expect(result.every((e) => e.amount >= 5.0 && e.amount <= 50.0), true);
    });

    test('should combine category + search filters', () {
      const filter = ExpenseFilter(
        searchQuery: 'coffee',
        categoryId: 'cat_food',
      );
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 2);
    });

    test('should return empty list when no expenses match', () {
      const filter = ExpenseFilter(searchQuery: 'nonexistent');
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result, isEmpty);
    });

    test('should handle empty expense list', () {
      const filter = ExpenseFilter();
      final result = useCase(expenses: [], filter: filter);

      expect(result, isEmpty);
    });

    test('should trim search query whitespace', () {
      const filter = ExpenseFilter(searchQuery: '  coffee  ');
      final result = useCase(expenses: tExpenses, filter: filter);

      expect(result.length, 2);
    });
  });

  group('ExpenseFilter', () {
    test('hasActiveFilters should be false for default filter', () {
      const filter = ExpenseFilter();
      expect(filter.hasActiveFilters, false);
    });

    test('hasActiveFilters should be true with search query', () {
      const filter = ExpenseFilter(searchQuery: 'test');
      expect(filter.hasActiveFilters, true);
    });

    test('hasActiveFilters should be true with category', () {
      const filter = ExpenseFilter(categoryId: 'cat_1');
      expect(filter.hasActiveFilters, true);
    });

    test('hasActiveFilters should be true with non-default sort', () {
      const filter = ExpenseFilter(sortOption: ExpenseSortOption.oldest);
      expect(filter.hasActiveFilters, true);
    });

    test('copyWith should clear categoryId when clearCategoryId is true', () {
      const filter = ExpenseFilter(categoryId: 'cat_1');
      final cleared = filter.copyWith(clearCategoryId: true);
      expect(cleared.categoryId, isNull);
    });

    test('copyWith should clear date range when clearDateRange is true', () {
      final filter = ExpenseFilter(
        startDate: DateTime(2026, 1, 1),
        endDate: DateTime(2026, 12, 31),
      );
      final cleared = filter.copyWith(clearDateRange: true);
      expect(cleared.startDate, isNull);
      expect(cleared.endDate, isNull);
    });

    test('copyWith should clear amount range when clearAmountRange is true', () {
      const filter = ExpenseFilter(minAmount: 5.0, maxAmount: 100.0);
      final cleared = filter.copyWith(clearAmountRange: true);
      expect(cleared.minAmount, isNull);
      expect(cleared.maxAmount, isNull);
    });

    test('equality should work correctly', () {
      const filter1 = ExpenseFilter(searchQuery: 'test', categoryId: 'cat_1');
      const filter2 = ExpenseFilter(searchQuery: 'test', categoryId: 'cat_1');
      const filter3 = ExpenseFilter(searchQuery: 'other', categoryId: 'cat_1');

      expect(filter1, filter2);
      expect(filter1, isNot(filter3));
    });
  });

  group('Budget entity', () {
    test('remainingAmount should return correct value', () {
      final budget = _makeBudget(limitAmount: 500.0, spentAmount: 200.0);
      expect(budget.remainingAmount, 300.0);
    });

    test('remainingAmount should be negative when exceeded', () {
      final budget = _makeBudget(limitAmount: 100.0, spentAmount: 150.0);
      expect(budget.remainingAmount, -50.0);
    });

    test('remainingAmount should equal limit when nothing spent', () {
      final budget = _makeBudget(limitAmount: 500.0, spentAmount: 0.0);
      expect(budget.remainingAmount, 500.0);
    });
  });
}

// Helper to avoid importing Budget directly (it's in a separate feature)
// We import it here since this is a cross-feature domain test

Budget _makeBudget({required double limitAmount, required double spentAmount}) {
  return Budget(
    id: 'b_1',
    categoryId: 'cat_1',
    limitAmount: limitAmount,
    spentAmount: spentAmount,
    period: BudgetPeriod.monthly,
    createdAt: DateTime(2026, 6, 1),
  );
}
