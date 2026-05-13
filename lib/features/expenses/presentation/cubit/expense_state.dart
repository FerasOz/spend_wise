import '../../domain/entities/expense.dart';
import '../../../../core/base/requests_status.dart';

enum ExpenseSortOption { newest, oldest, highestAmount, lowestAmount }

class ExpenseState {
  ExpenseState({
    this.expensesStatus = RequestsStatus.initial,
    this.submissionStatus = RequestsStatus.initial,
    this.expenses = const [],
    DateTime? selectedDate,
    this.selectedCategoryId,
    this.searchQuery = '',
    this.categoryFilterId,
    this.filterStartDate,
    this.filterEndDate,
    this.sortOption = ExpenseSortOption.newest,
    this.loadErrorMessage,
    this.submissionErrorMessage,
  }) : selectedDate = selectedDate ?? DateTime.now();

  final RequestsStatus expensesStatus;
  final RequestsStatus submissionStatus;
  final DateTime selectedDate;
  final String? selectedCategoryId;
  final String searchQuery;
  final String? categoryFilterId;
  final DateTime? filterStartDate;
  final DateTime? filterEndDate;
  final ExpenseSortOption sortOption;
  final String? loadErrorMessage;
  final String? submissionErrorMessage;
  final List<Expense> expenses;

  ExpenseState copyWith({
    RequestsStatus? expensesStatus,
    RequestsStatus? submissionStatus,
    List<Expense>? expenses,
    DateTime? selectedDate,
    String? selectedCategoryId,
    String? searchQuery,
    String? categoryFilterId,
    DateTime? filterStartDate,
    DateTime? filterEndDate,
    ExpenseSortOption? sortOption,
    String? loadErrorMessage,
    String? submissionErrorMessage,
    bool clearSelectedCategoryId = false,
    bool clearLoadErrorMessage = false,
    bool clearSubmissionErrorMessage = false,
    bool clearDateFilters = false,
  }) {
    return ExpenseState(
      expensesStatus: expensesStatus ?? this.expensesStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      expenses: expenses ?? this.expenses,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedCategoryId: clearSelectedCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilterId: categoryFilterId ?? this.categoryFilterId,
      filterStartDate: clearDateFilters
          ? null
          : (filterStartDate ?? this.filterStartDate),
      filterEndDate: clearDateFilters
          ? null
          : (filterEndDate ?? this.filterEndDate),
      sortOption: sortOption ?? this.sortOption,
      loadErrorMessage: clearLoadErrorMessage
          ? null
          : (loadErrorMessage ?? this.loadErrorMessage),
      submissionErrorMessage: clearSubmissionErrorMessage
          ? null
          : (submissionErrorMessage ?? this.submissionErrorMessage),
    );
  }
}
