import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/requests_status.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_filter.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/get_visible_expenses.dart';
import '../../domain/usecases/update_expense.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit({
    required AddExpense addExpense,
    required GetExpenses getExpenses,
    required UpdateExpense updateExpense,
    required DeleteExpense deleteExpense,
    required GetVisibleExpenses getVisibleExpenses,
  }) : _addExpense = addExpense,
       _getExpenses = getExpenses,
       _updateExpense = updateExpense,
       _deleteExpense = deleteExpense,
       _getVisibleExpenses = getVisibleExpenses,
       super(ExpenseState());

  final AddExpense _addExpense;
  final GetExpenses _getExpenses;
  final UpdateExpense _updateExpense;
  final DeleteExpense _deleteExpense;
  final GetVisibleExpenses _getVisibleExpenses;

  void initializeForm([Expense? expense]) {
    emit(
      state.copyWith(
        selectedDate: expense?.date ?? DateTime.now(),
        selectedCategoryId: expense?.categoryId,
        clearSelectedCategoryId: expense == null,
        submissionStatus: RequestsStatus.initial,
        clearSubmissionErrorMessage: true,
      ),
    );
  }

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setSelectedCategoryId(String? categoryId) {
    if (state.selectedCategoryId == categoryId) return;
    emit(state.copyWith(selectedCategoryId: categoryId));
  }

  void setSearchQuery(String query) {
    _emitWithVisibleExpenses(filter: state.filter.copyWith(searchQuery: query));
  }

  void setCategoryFilterId(String? categoryId) {
    if (state.categoryFilterId == categoryId) return;
    _emitWithVisibleExpenses(
      filter: state.filter.copyWith(
        categoryId: categoryId,
        clearCategoryId: categoryId == null,
      ),
    );
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _emitWithVisibleExpenses(
      filter: state.filter.copyWith(startDate: start, endDate: end),
    );
  }

  void clearDateFilters() {
    _emitWithVisibleExpenses(filter: state.filter.copyWith(clearDateRange: true));
  }

  void setSortOption(ExpenseSortOption option) {
    if (state.sortOption == option) return;
    _emitWithVisibleExpenses(filter: state.filter.copyWith(sortOption: option));
  }

  void clearAllFilters() {
    _emitWithVisibleExpenses(filter: const ExpenseFilter());
  }

  void resetExpenseForm() {
    initializeForm();
  }

  Future<void> loadExpenses() async {
    emit(
      state.copyWith(
        expensesStatus: RequestsStatus.loading,
        clearLoadErrorMessage: true,
      ),
    );

    try {
      final expenses = await _getExpenses();
      _emitWithVisibleExpenses(
        expenses: List<Expense>.unmodifiable(expenses),
        state: state.copyWith(
          expensesStatus: RequestsStatus.success,
          clearLoadErrorMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          expensesStatus: RequestsStatus.error,
          loadErrorMessage: _mapErrorToMessage(
            error,
            fallback: 'Failed to load expenses.',
          ),
        ),
      );
    }
  }

  Future<void> addExpense(Expense expense) async {
    await _performSubmission(
      action: () => _addExpense(expense),
      onSuccess: () {
        _emitWithVisibleExpenses(
          expenses: List<Expense>.unmodifiable([...state.expenses, expense]),
          state: state.copyWith(
            expensesStatus: RequestsStatus.success,
            submissionStatus: RequestsStatus.success,
            selectedDate: DateTime.now(),
            clearSelectedCategoryId: true,
            clearLoadErrorMessage: true,
            clearSubmissionErrorMessage: true,
          ),
        );
      },
      fallbackErrorMessage: 'Failed to add expense.',
    );
  }

  Future<void> updateExpense(Expense expense) async {
    await _performSubmission(
      action: () => _updateExpense(expense),
      onSuccess: () {
        _emitWithVisibleExpenses(
          expenses: _replaceExpense(expense),
          state: state.copyWith(
            expensesStatus: RequestsStatus.success,
            submissionStatus: RequestsStatus.success,
            selectedDate: DateTime.now(),
            clearSelectedCategoryId: true,
            clearLoadErrorMessage: true,
            clearSubmissionErrorMessage: true,
          ),
        );
      },
      fallbackErrorMessage: 'Failed to update expense.',
    );
  }

  Future<void> deleteExpense(String id) async {
    final currentExpenses = state.expenses;

    _emitWithVisibleExpenses(
      expenses: _removeExpense(id),
      state: state.copyWith(
        submissionStatus: RequestsStatus.loading,
        clearSubmissionErrorMessage: true,
      ),
    );

    try {
      await _deleteExpense(id);
      emit(
        state.copyWith(
          expensesStatus: RequestsStatus.success,
          submissionStatus: RequestsStatus.success,
          clearLoadErrorMessage: true,
          clearSubmissionErrorMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      _emitWithVisibleExpenses(
        expenses: currentExpenses,
        state: state.copyWith(
          submissionStatus: RequestsStatus.error,
          submissionErrorMessage: _mapErrorToMessage(
            error,
            fallback: 'Failed to delete expense.',
          ),
        ),
      );
    }
  }

  Future<void> _performSubmission({
    required Future<void> Function() action,
    required void Function() onSuccess,
    required String fallbackErrorMessage,
  }) async {
    emit(
      state.copyWith(
        submissionStatus: RequestsStatus.loading,
        clearSubmissionErrorMessage: true,
      ),
    );

    try {
      await action();
      onSuccess();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          submissionStatus: RequestsStatus.error,
          submissionErrorMessage: _mapErrorToMessage(
            error,
            fallback: fallbackErrorMessage,
          ),
        ),
      );
    }
  }

  void _emitWithVisibleExpenses({
    ExpenseState? state,
    List<Expense>? expenses,
    ExpenseFilter? filter,
  }) {
    final nextState = state ?? this.state;
    final nextExpenses = expenses ?? nextState.expenses;
    final nextFilter = filter ?? nextState.filter;

    emit(
      nextState.copyWith(
        expenses: nextExpenses,
        filter: nextFilter,
        visibleExpenses: List<Expense>.unmodifiable(
          _getVisibleExpenses(expenses: nextExpenses, filter: nextFilter),
        ),
      ),
    );
  }

  List<Expense> _replaceExpense(Expense updatedExpense) {
    return List<Expense>.unmodifiable(
      state.expenses.map((expense) {
        return expense.id == updatedExpense.id ? updatedExpense : expense;
      }),
    );
  }

  List<Expense> _removeExpense(String id) {
    return List<Expense>.unmodifiable(
      state.expenses.where((expense) => expense.id != id),
    );
  }

  String _mapErrorToMessage(Object error, {required String fallback}) {
    final message = error.toString().trim();
    if (message.isEmpty || message == 'Exception') {
      return fallback;
    }

    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }
}
