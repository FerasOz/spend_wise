enum RecurringRepeatType { weekly, monthly, yearly }

class RecurringExpense {
  const RecurringExpense({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.repeatType,
    required this.nextDueDate,
    this.isActive = true,
    required this.createdAt,
  });

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final RecurringRepeatType repeatType;
  final DateTime nextDueDate;
  final bool isActive;
  final DateTime createdAt;

  RecurringExpense copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    RecurringRepeatType? repeatType,
    DateTime? nextDueDate,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RecurringExpense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      repeatType: repeatType ?? this.repeatType,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
