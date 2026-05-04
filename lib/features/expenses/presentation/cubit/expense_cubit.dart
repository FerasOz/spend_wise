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

  void setSelectedDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  void setSelectedCategoryId(String? categoryId) {
    if (state.selectedCategoryId == categoryId) return;
    emit(state.copyWith(selectedCategoryId: categoryId));
  }

  void resetExpenseForm() {
    emit(
      state.copyWith(
        selectedDate: DateTime.now(),
        selectedCategoryId: null,
        submissionStatus: RequestsStatus.initial,
        clearSubmissionErrorMessage: true,
      ),
    );
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
            selectedCategoryId: null,
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
            selectedCategoryId: null,
            clearLoadErrorMessage: true,
            clearSubmissionErrorMessage: true,
          ),
        );
      },
      fallbackErrorMessage: 'Failed to update expense.',
    );
  }

  Future<void> deleteExpense(String id) async {
    await _performSubmission(
      action: () => _deleteExpense(id),
      onSuccess: () {
        emit(
          state.copyWith(
            expenses: _removeExpense(id),
            expensesStatus: RequestsStatus.success,
            submissionStatus: RequestsStatus.success,
            selectedCategoryId: null,
            clearLoadErrorMessage: true,
            clearSubmissionErrorMessage: true,
          ),
        );
      },
      fallbackErrorMessage: 'Failed to delete expense.',
    );
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
