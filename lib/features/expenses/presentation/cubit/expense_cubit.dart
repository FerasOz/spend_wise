import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/base/requests_status.dart';
import '../../../../core/services/app_clock.dart';
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
    required AppClock clock,
  }) : _addExpense = addExpense,
       _getExpenses = getExpenses,
       _updateExpense = updateExpense,
       _deleteExpense = deleteExpense,
       _clock = clock,
       super(ExpenseState(selectedDate: clock.now(), clock: clock));

  final AddExpense _addExpense;
  final GetExpenses _getExpenses;
  final UpdateExpense _updateExpense;
  final DeleteExpense _deleteExpense;
  final AppClock _clock;

  DateTime get now => _clock.now();

  void initializeForm([Expense? expense]) {
    emit(
      state.copyWith(
        selectedDate: expense?.date ?? _clock.now(),
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
      emit(
        state.copyWith(
          expensesStatus: RequestsStatus.success,
          expenses: List<Expense>.unmodifiable(expenses),
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
            fallback: LocaleKeys.expenses_messages_failedLoad.tr(),
          ),
        ),
      );
    }
  }

  Future<void> addExpense(Expense expense) async {
    await _performSubmission(
      action: () => _addExpense(expense),
      onSuccess: () async {
        await loadExpenses();
        emit(
          state.copyWith(
            submissionStatus: RequestsStatus.success,
            selectedDate: now,
            clearSelectedCategoryId: true,
            clearLoadErrorMessage: true,
            clearSubmissionErrorMessage: true,
          ),
        );
      },
      fallbackErrorMessage: LocaleKeys.expenses_messages_failedAdd.tr(),
    );
  }

  Future<void> updateExpense(Expense expense) async {
    await _performSubmission(
      action: () => _updateExpense(expense),
      onSuccess: () async {
        await loadExpenses();
        emit(
          state.copyWith(
            submissionStatus: RequestsStatus.success,
            selectedDate: now,
            clearSelectedCategoryId: true,
            clearLoadErrorMessage: true,
            clearSubmissionErrorMessage: true,
          ),
        );
      },
      fallbackErrorMessage: LocaleKeys.expenses_messages_failedUpdate.tr(),
    );
  }

  Future<void> deleteExpense(String id) async {
    final currentExpenses = state.expenses;

    emit(
      state.copyWith(
        expenses: _removeExpense(id),
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
            fallback: LocaleKeys.expenses_messages_failedDelete.tr(),
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
