import '../../../../core/base/requests_status.dart';
import '../../domain/entities/budget_progress.dart';

class BudgetState {
  const BudgetState({
    this.status = RequestsStatus.initial,
    this.submissionStatus = RequestsStatus.initial,
    this.budgets = const [],
    this.errorMessage,
    this.submissionMessage,
  });

  final RequestsStatus status;
  final RequestsStatus submissionStatus;
  final List<BudgetProgress> budgets;
  final String? errorMessage;
  final String? submissionMessage;

  BudgetState copyWith({
    RequestsStatus? status,
    RequestsStatus? submissionStatus,
    List<BudgetProgress>? budgets,
    String? errorMessage,
    String? submissionMessage,
    bool clearErrorMessage = false,
    bool clearSubmissionMessage = false,
  }) {
    return BudgetState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      budgets: budgets ?? this.budgets,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      submissionMessage: clearSubmissionMessage
          ? null
          : (submissionMessage ?? this.submissionMessage),
    );
  }
}
