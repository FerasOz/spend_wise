import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/generated/locale_keys.g.dart';

import '../../../../core/base/requests_status.dart';
import '../../domain/entities/recurring_expense.dart';
import '../../domain/usecases/create_recurring_expense.dart';
import '../../domain/usecases/delete_recurring_expense.dart';
import '../../domain/usecases/generate_due_expenses.dart';
import '../../domain/usecases/get_recurring_expenses.dart';
import '../../domain/usecases/update_recurring_expense.dart';
import 'recurring_expense_state.dart';

class RecurringExpenseCubit extends Cubit<RecurringExpenseState> {
  RecurringExpenseCubit({
    required CreateRecurringExpense createRecurringExpense,
    required GetRecurringExpenses getRecurringExpenses,
    required UpdateRecurringExpense updateRecurringExpense,
    required DeleteRecurringExpense deleteRecurringExpense,
    required GenerateDueExpenses generateDueExpenses,
  }) : _createRecurringExpense = createRecurringExpense,
       _getRecurringExpenses = getRecurringExpenses,
       _updateRecurringExpense = updateRecurringExpense,
       _deleteRecurringExpense = deleteRecurringExpense,
       _generateDueExpenses = generateDueExpenses,
       super(const RecurringExpenseState());

  final CreateRecurringExpense _createRecurringExpense;
  final GetRecurringExpenses _getRecurringExpenses;
  final UpdateRecurringExpense _updateRecurringExpense;
  final DeleteRecurringExpense _deleteRecurringExpense;
  final GenerateDueExpenses _generateDueExpenses;

  void initializeForm([RecurringExpense? recurringExpense]) {
    emit(
      state.copyWith(
        selectedTitle: recurringExpense?.title ?? '',
        selectedAmount: recurringExpense?.amount.toString() ?? '',
        selectedCategoryId: recurringExpense?.categoryId,
        selectedRepeatType: recurringExpense?.repeatType ?? RecurringRepeatType.monthly,
        selectedDueDate: recurringExpense?.nextDueDate ?? DateTime.now(),
        clearSelectedCategoryId: recurringExpense == null,
        submissionStatus: RequestsStatus.initial,
        clearSubmissionErrorMessage: true,
      ),
    );
  }

  Future<void> initialize() async {
    await _generateAndTrackDueExpenses();
    await loadRecurringExpenses();
  }

  Future<void> loadRecurringExpenses() async {
    emit(
      state.copyWith(status: RequestsStatus.loading, clearErrorMessage: true),
    );

    try {
      final recurringExpenses = await _getRecurringExpenses();
      emit(
        state.copyWith(
          status: RequestsStatus.success,
          recurringExpenses: recurringExpenses,
          clearErrorMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: RequestsStatus.error,
          errorMessage: _mapError(
            error,
            LocaleKeys.recurring_errorMessage_failedLoad.tr(),
          ),
        ),
      );
    }
  }

  Future<void> createRecurringExpense(RecurringExpense recurringExpense) async {
    await _submit(
      action: () => _createRecurringExpense(recurringExpense),
      successMessage: LocaleKeys.recurring_successMessage_create.tr(),
    );
  }

  Future<void> updateRecurringExpense(RecurringExpense recurringExpense) async {
    await _submit(
      action: () => _updateRecurringExpense(recurringExpense),
      successMessage: LocaleKeys.recurring_successMessage_update.tr(),
    );
  }

  Future<void> deleteRecurringExpense(String id) async {
    await _submit(
      action: () => _deleteRecurringExpense(id),
      successMessage: LocaleKeys.recurring_successMessage_delete.tr(),
    );
  }

  Future<void> toggleActive(RecurringExpense recurringExpense, bool isActive) async {
    await updateRecurringExpense(
      recurringExpense.copyWith(isActive: isActive),
    );
  }

  Future<void> _submit({
    required Future<void> Function() action,
    required String successMessage,
  }) async {
    emit(
      state.copyWith(
        submissionStatus: RequestsStatus.loading,
        clearSubmissionMessage: true,
      ),
    );

    try {
      await action();
      await _generateAndTrackDueExpenses();
      emit(
        state.copyWith(
          submissionStatus: RequestsStatus.success,
          submissionMessage: successMessage,
        ),
      );
      await loadRecurringExpenses();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          submissionStatus: RequestsStatus.error,
          submissionMessage: _mapError(
            error,
            LocaleKeys.recurring_errorMessage_failedAction.tr(),
          ),
        ),
      );
    }
  }

  String _mapError(Object error, String fallback) {
    final message = error.toString().trim();
    if (message.isEmpty || message == 'Exception') return fallback;
    return message.startsWith('Exception: ')
        ? message.substring('Exception: '.length)
        : message;
  }

  Future<void> _generateAndTrackDueExpenses() async {
    final generatedExpenseCount = await _generateDueExpenses();
    if (generatedExpenseCount == 0) {
      return;
    }

    emit(
      state.copyWith(
        generatedExpenseCount:
            state.generatedExpenseCount + generatedExpenseCount,
      ),
    );
  }
}
