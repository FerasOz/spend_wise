import '../../domain/entities/recurring_expense.dart';

class RecurringExpenseModel {
  const RecurringExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.repeatType,
    required this.nextDueDate,
    required this.isActive,
    required this.createdAt,
  });

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final String repeatType;
  final DateTime nextDueDate;
  final bool isActive;
  final DateTime createdAt;

  factory RecurringExpenseModel.fromEntity(RecurringExpense recurringExpense) {
    return RecurringExpenseModel(
      id: recurringExpense.id,
      title: recurringExpense.title,
      amount: recurringExpense.amount,
      categoryId: recurringExpense.categoryId,
      repeatType: recurringExpense.repeatType.name,
      nextDueDate: recurringExpense.nextDueDate,
      isActive: recurringExpense.isActive,
      createdAt: recurringExpense.createdAt,
    );
  }

  factory RecurringExpenseModel.fromMap(Map<String, dynamic> map) {
    return RecurringExpenseModel(
      id: map['id'] as String,
      title: map['title'] as String,
      amount: (map['amount'] as num).toDouble(),
      categoryId: map['categoryId'] as String,
      repeatType: map['repeatType'] as String,
      nextDueDate: DateTime.parse(map['nextDueDate'] as String),
      isActive: map['isActive'] as bool,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'categoryId': categoryId,
      'repeatType': repeatType,
      'nextDueDate': nextDueDate.toIso8601String(),
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  RecurringExpense toEntity() {
    return RecurringExpense(
      id: id,
      title: title,
      amount: amount,
      categoryId: categoryId,
      repeatType: RecurringRepeatType.values.firstWhere(
        (value) => value.name == repeatType,
        orElse: () => RecurringRepeatType.monthly,
      ),
      nextDueDate: nextDueDate,
      isActive: isActive,
      createdAt: createdAt,
    );
  }
}
