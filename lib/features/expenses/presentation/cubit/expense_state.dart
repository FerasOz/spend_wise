import '../../domain/entities/expense.dart';
import '../../../../core/base/requests_status.dart';

class ExpenseState {
  ExpenseState({
    this.expensesStatus = RequestsStatus.initial,
    this.submissionStatus = RequestsStatus.initial,
    this.expenses = const [],
    DateTime? selectedDate,
    this.loadErrorMessage,
    this.submissionErrorMessage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  final RequestsStatus expensesStatus;
  final RequestsStatus submissionStatus;
  final DateTime selectedDate;
  final String? loadErrorMessage;
  final String? submissionErrorMessage;
  final List<Expense> expenses;

  ExpenseState copyWith({
    RequestsStatus? expensesStatus,
    RequestsStatus? submissionStatus,
    List<Expense>? expenses,
    DateTime? selectedDate,
    String? loadErrorMessage,
    String? submissionErrorMessage,
    bool clearLoadErrorMessage = false,
    bool clearSubmissionErrorMessage = false,
  }) {
    return ExpenseState(
      expensesStatus: expensesStatus ?? this.expensesStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      expenses: expenses ?? this.expenses,
      selectedDate: selectedDate ?? this.selectedDate,
      loadErrorMessage: clearLoadErrorMessage
          ? null
          : (loadErrorMessage ?? this.loadErrorMessage),
      submissionErrorMessage: clearSubmissionErrorMessage
          ? null
          : (submissionErrorMessage ?? this.submissionErrorMessage),
    );
  }
}
