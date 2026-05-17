import '../../../../core/base/requests_status.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/expense_filter.dart';

class ExpenseState {
  ExpenseState({
    this.expensesStatus = RequestsStatus.initial,
    this.submissionStatus = RequestsStatus.initial,
    this.expenses = const [],
    this.visibleExpenses = const [],
    DateTime? selectedDate,
    this.selectedCategoryId,
    this.filter = const ExpenseFilter(),
    this.loadErrorMessage,
    this.submissionErrorMessage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  final RequestsStatus expensesStatus;
  final RequestsStatus submissionStatus;
  final List<Expense> expenses;
  final List<Expense> visibleExpenses;
  final DateTime selectedDate;
  final String? selectedCategoryId;
  final ExpenseFilter filter;
  final String? loadErrorMessage;
  final String? submissionErrorMessage;

  String get searchQuery => filter.searchQuery;
  String? get categoryFilterId => filter.categoryId;
  DateTime? get filterStartDate => filter.startDate;
  DateTime? get filterEndDate => filter.endDate;
  ExpenseSortOption get sortOption => filter.sortOption;
  bool get hasActiveFilters => filter.hasActiveFilters;

  ExpenseState copyWith({
    RequestsStatus? expensesStatus,
    RequestsStatus? submissionStatus,
    List<Expense>? expenses,
    List<Expense>? visibleExpenses,
    DateTime? selectedDate,
    String? selectedCategoryId,
    ExpenseFilter? filter,
    String? loadErrorMessage,
    String? submissionErrorMessage,
    bool clearSelectedCategoryId = false,
    bool clearLoadErrorMessage = false,
    bool clearSubmissionErrorMessage = false,
  }) {
    return ExpenseState(
      expensesStatus: expensesStatus ?? this.expensesStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      expenses: expenses ?? this.expenses,
      visibleExpenses: visibleExpenses ?? this.visibleExpenses,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      filter: filter ?? this.filter,
      loadErrorMessage: clearLoadErrorMessage
          ? null
          : (loadErrorMessage ?? this.loadErrorMessage),
      submissionErrorMessage: clearSubmissionErrorMessage
          ? null
          : (submissionErrorMessage ?? this.submissionErrorMessage),
    );
  }
}
