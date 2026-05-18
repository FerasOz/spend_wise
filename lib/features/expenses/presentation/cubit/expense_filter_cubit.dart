import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_filter.dart';
import '../../domain/usecases/get_visible_expenses.dart';
import 'expense_filter_state.dart';

class ExpenseFilterCubit extends Cubit<ExpenseFilterState> {
  ExpenseFilterCubit({required GetVisibleExpenses getVisibleExpenses})
    : _getVisibleExpenses = getVisibleExpenses,
      super(const ExpenseFilterState());

  final GetVisibleExpenses _getVisibleExpenses;

  void syncExpenses(List<Expense> expenses) {
    if (identical(expenses, state.sourceExpenses)) return;
    _emitWith(filter: state.filter, sourceExpenses: expenses);
  }

  void setSearchQuery(String query) {
    _emitWith(filter: state.filter.copyWith(searchQuery: query));
  }

  void setCategoryFilterId(String? categoryId) {
    if (state.categoryFilterId == categoryId) return;
    _emitWith(
      filter: state.filter.copyWith(
        categoryId: categoryId,
        clearCategoryId: categoryId == null,
      ),
    );
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _emitWith(filter: state.filter.copyWith(startDate: start, endDate: end));
  }

  void clearDateFilters() {
    _emitWith(filter: state.filter.copyWith(clearDateRange: true));
  }

  void setAmountRange(double? minAmount, double? maxAmount) {
    _emitWith(
      filter: state.filter.copyWith(
        minAmount: minAmount,
        maxAmount: maxAmount,
        clearAmountRange: minAmount == null && maxAmount == null,
      ),
    );
  }

  void setSortOption(ExpenseSortOption option) {
    if (state.sortOption == option) return;
    _emitWith(filter: state.filter.copyWith(sortOption: option));
  }

  void clearAll() {
    _emitWith(filter: const ExpenseFilter());
  }

  void _emitWith({
    required ExpenseFilter filter,
    List<Expense>? sourceExpenses,
  }) {
    final nextSourceExpenses = sourceExpenses ?? state.sourceExpenses;
    emit(
      state.copyWith(
        filter: filter,
        sourceExpenses: nextSourceExpenses,
        visibleExpenses: List<Expense>.unmodifiable(
          _getVisibleExpenses(
            expenses: nextSourceExpenses,
            filter: filter,
          ),
        ),
      ),
    );
  }
}
