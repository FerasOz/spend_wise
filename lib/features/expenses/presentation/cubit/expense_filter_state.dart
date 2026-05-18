import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_filter.dart';

class ExpenseFilterState {
  const ExpenseFilterState({
    this.filter = const ExpenseFilter(),
    this.sourceExpenses = const [],
    this.visibleExpenses = const [],
  });

  final ExpenseFilter filter;
  final List<Expense> sourceExpenses;
  final List<Expense> visibleExpenses;

  bool get hasActiveFilters => filter.hasActiveFilters;
  String get searchQuery => filter.searchQuery;
  String? get categoryFilterId => filter.categoryId;
  DateTime? get filterStartDate => filter.startDate;
  DateTime? get filterEndDate => filter.endDate;
  double? get minAmount => filter.minAmount;
  double? get maxAmount => filter.maxAmount;
  ExpenseSortOption get sortOption => filter.sortOption;

  ExpenseFilterState copyWith({
    ExpenseFilter? filter,
    List<Expense>? sourceExpenses,
    List<Expense>? visibleExpenses,
  }) {
    return ExpenseFilterState(
      filter: filter ?? this.filter,
      sourceExpenses: sourceExpenses ?? this.sourceExpenses,
      visibleExpenses: visibleExpenses ?? this.visibleExpenses,
    );
  }
}
