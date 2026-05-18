import '../../../../core/base/requests_status.dart';
import '../../domain/entities/recurring_expense.dart';

class RecurringExpenseState {
  const RecurringExpenseState({
    this.status = RequestsStatus.initial,
    this.submissionStatus = RequestsStatus.initial,
    this.recurringExpenses = const [],
    this.generatedExpenseCount = 0,
    this.errorMessage,
    this.submissionMessage,
  });

  final RequestsStatus status;
  final RequestsStatus submissionStatus;
  final List<RecurringExpense> recurringExpenses;
  final int generatedExpenseCount;
  final String? errorMessage;
  final String? submissionMessage;

  RecurringExpenseState copyWith({
    RequestsStatus? status,
    RequestsStatus? submissionStatus,
    List<RecurringExpense>? recurringExpenses,
    int? generatedExpenseCount,
    String? errorMessage,
    String? submissionMessage,
    bool clearErrorMessage = false,
    bool clearSubmissionMessage = false,
  }) {
    return RecurringExpenseState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      recurringExpenses: recurringExpenses ?? this.recurringExpenses,
      generatedExpenseCount: generatedExpenseCount ?? this.generatedExpenseCount,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      submissionMessage: clearSubmissionMessage
          ? null
          : (submissionMessage ?? this.submissionMessage),
    );
  }
}
