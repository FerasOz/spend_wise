import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/requests_status.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/add_expense.dart';
import '../../domain/usecases/delete_expense.dart';
import '../../domain/usecases/get_expenses.dart';
import '../../domain/usecases/update_expense.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  ExpenseCubit({
    required AddExpense addExpense,
    required GetExpenses getExpenses,
    required UpdateExpense updateExpense,
    required DeleteExpense deleteExpense,
  }) : _addExpense = addExpense,
       _getExpenses = getExpenses,
       _updateExpense = updateExpense,
       _deleteExpense = deleteExpense,
       super(ExpenseState());

  final AddExpense _addExpense;
  final GetExpenses _getExpenses;
  final UpdateExpense _updateExpense;
  final DeleteExpense _deleteExpense;

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
    emit(state.copyWith(searchQuery: query));
  }

  void setCategoryFilterId(String? categoryId) {
    if (state.categoryFilterId == categoryId) return;
    emit(state.copyWith(categoryFilterId: categoryId));
  }

  void setDateRange(DateTime? start, DateTime? end) {
    emit(state.copyWith(filterStartDate: start, filterEndDate: end));
  }

  void clearDateFilters() {
    emit(state.copyWith(clearDateFilters: true));
  }

  void setSortOption(ExpenseSortOption option) {
    if (state.sortOption == option) return;
    emit(state.copyWith(sortOption: option));
  }

  void clearAllFilters() {
    emit(
      state.copyWith(
        searchQuery: '',
        categoryFilterId: null,
        filterStartDate: null,
        filterEndDate: null,
        sortOption: ExpenseSortOption.newest,
      ),
    );
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
      final expenses = await _fetchExpenses();
      _emitLoadSuccess(expenses);
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
        emit(
          state.copyWith(
            expenses: List<Expense>.unmodifiable([...state.expenses, expense]),
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
        emit(
          state.copyWith(
            expenses: _replaceExpense(expense),
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
    final updatedExpenses = _removeExpense(id);

    emit(
      state.copyWith(
        expenses: updatedExpenses,
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
      emit(
        state.copyWith(
          expenses: currentExpenses,
          submissionStatus: RequestsStatus.error,
          submissionErrorMessage: _mapErrorToMessage(
            error,
            fallback: 'Failed to delete expense.',
          ),
        ),
      );
    }
  }

  Future<List<Expense>> _fetchExpenses() {
    return _getExpenses();
  }

  Future<void> _performSubmission({
    required Future<void> Function() action,
    required void Function() onSuccess,
    required String fallbackErrorMessage,
  }) async {
    _emitSubmissionLoading();

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

  void _emitSubmissionLoading() {
    emit(
      state.copyWith(
        submissionStatus: RequestsStatus.loading,
        clearSubmissionErrorMessage: true,
      ),
    );
  }

  void _emitLoadSuccess(List<Expense> expenses) {
    emit(
      state.copyWith(
        expensesStatus: RequestsStatus.success,
        expenses: List<Expense>.unmodifiable(expenses),
        clearLoadErrorMessage: true,
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
