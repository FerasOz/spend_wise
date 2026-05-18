enum ExpenseSortOption { newest, oldest, highestAmount, lowestAmount }

class ExpenseFilter {
  const ExpenseFilter({
    this.searchQuery = '',
    this.categoryId,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
    this.sortOption = ExpenseSortOption.newest,
  });

  final String searchQuery;
  final String? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;
  final ExpenseSortOption sortOption;

  ExpenseFilter copyWith({
    String? searchQuery,
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    ExpenseSortOption? sortOption,
    bool clearCategoryId = false,
    bool clearDateRange = false,
    bool clearAmountRange = false,
  }) {
    return ExpenseFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      startDate: clearDateRange ? null : (startDate ?? this.startDate),
      endDate: clearDateRange ? null : (endDate ?? this.endDate),
      minAmount: clearAmountRange ? null : (minAmount ?? this.minAmount),
      maxAmount: clearAmountRange ? null : (maxAmount ?? this.maxAmount),
      sortOption: sortOption ?? this.sortOption,
    );
  }

  bool get hasActiveFilters {
    return searchQuery.isNotEmpty ||
        categoryId != null ||
        startDate != null ||
        endDate != null ||
        minAmount != null ||
        maxAmount != null ||
        sortOption != ExpenseSortOption.newest;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ExpenseFilter &&
        other.searchQuery == searchQuery &&
        other.categoryId == categoryId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.minAmount == minAmount &&
        other.maxAmount == maxAmount &&
        other.sortOption == sortOption;
  }

  @override
  int get hashCode => Object.hash(
    searchQuery,
    categoryId,
    startDate,
    endDate,
    minAmount,
    maxAmount,
    sortOption,
  );
}
