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
    // Form fields
    this.selectedTitle = '',
    this.selectedAmount = '',
    this.selectedCategoryId,
    this.selectedRepeatType,
    this.selectedDueDate,
    this.clearSelectedCategoryId = false,
    this.clearSubmissionErrorMessage = true,
  });

  final RequestsStatus status;
  final RequestsStatus submissionStatus;
  final List<RecurringExpense> recurringExpenses;
  final int generatedExpenseCount;
  final String? errorMessage;
  final String? submissionMessage;
  final String selectedTitle;
  final String selectedAmount;
  final String? selectedCategoryId;
  final RecurringRepeatType? selectedRepeatType;
  final DateTime? selectedDueDate;
  final bool clearSelectedCategoryId;
  final bool clearSubmissionErrorMessage;

  RecurringExpenseState copyWith({
    RequestsStatus? status,
    RequestsStatus? submissionStatus,
    List<RecurringExpense>? recurringExpenses,
    int? generatedExpenseCount,
    String? errorMessage,
    String? submissionMessage,
    String? selectedTitle,
    String? selectedAmount,
    String? selectedCategoryId,
    RecurringRepeatType? selectedRepeatType,
    DateTime? selectedDueDate,
    bool? clearSelectedCategoryId,
    bool? clearSubmissionErrorMessage,
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
      selectedTitle: selectedTitle ?? this.selectedTitle,
      selectedAmount: selectedAmount ?? this.selectedAmount,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedRepeatType: selectedRepeatType ?? this.selectedRepeatType,
      selectedDueDate: selectedDueDate ?? this.selectedDueDate,
      clearSelectedCategoryId: clearSelectedCategoryId ?? this.clearSelectedCategoryId,
      clearSubmissionErrorMessage: clearSubmissionErrorMessage ?? this.clearSubmissionErrorMessage,
    );
  }
}
