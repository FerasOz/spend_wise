import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/requests_status.dart';
import '../../domain/entities/budget.dart';
import '../../domain/usecases/calculate_budget_progress.dart';
import '../../domain/usecases/create_budget.dart';
import '../../domain/usecases/delete_budget.dart';
import '../../domain/usecases/get_budgets.dart';
import '../../domain/usecases/update_budget.dart';
import 'budget_state.dart';

class BudgetCubit extends Cubit<BudgetState> {
  BudgetCubit({
    required CreateBudget createBudget,
    required GetBudgets getBudgets,
    required UpdateBudget updateBudget,
    required DeleteBudget deleteBudget,
    required CalculateBudgetProgress calculateBudgetProgress,
  }) : _createBudget = createBudget,
       _getBudgets = getBudgets,
       _updateBudget = updateBudget,
       _deleteBudget = deleteBudget,
       _calculateBudgetProgress = calculateBudgetProgress,
       super(const BudgetState());

  final CreateBudget _createBudget;
  final GetBudgets _getBudgets;
  final UpdateBudget _updateBudget;
  final DeleteBudget _deleteBudget;
  final CalculateBudgetProgress _calculateBudgetProgress;

  Future<void> loadBudgets() async {
    emit(state.copyWith(status: RequestsStatus.loading, clearErrorMessage: true));

    try {
      final budgets = await _getBudgets();
      emit(
        state.copyWith(
          status: RequestsStatus.success,
          budgets: budgets.map(_calculateBudgetProgress).toList(growable: false),
          clearErrorMessage: true,
        ),
      );
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          status: RequestsStatus.error,
          errorMessage: _mapError(error, 'Failed to load budgets.'),
        ),
      );
    }
  }

  Future<void> createBudget(Budget budget) {
    return _submit(
      action: () => _createBudget(budget),
      successMessage: 'Budget created successfully.',
    );
  }

  Future<void> updateBudget(Budget budget) {
    return _submit(
      action: () => _updateBudget(budget),
      successMessage: 'Budget updated successfully.',
    );
  }

  Future<void> deleteBudget(String id) {
    return _submit(
      action: () => _deleteBudget(id),
      successMessage: 'Budget deleted successfully.',
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
      emit(
        state.copyWith(
          submissionStatus: RequestsStatus.success,
          submissionMessage: successMessage,
        ),
      );
      await loadBudgets();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      emit(
        state.copyWith(
          submissionStatus: RequestsStatus.error,
          submissionMessage: _mapError(error, 'Budget action failed.'),
        ),
      );
    }
  }

  String _mapError(Object error, String fallback) {
    final message = error.toString().trim();
    if (message.isEmpty || message == 'Exception') {
      return fallback;
    }
    return message.startsWith('Exception: ')
        ? message.substring('Exception: '.length)
        : message;
  }
}
