import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/recurring_expense.dart';

part 'recurring_expense_model.g.dart';

@JsonSerializable()
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

  factory RecurringExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringExpenseModelFromJson(json);

  factory RecurringExpenseModel.fromRemoteJson(Map<String, dynamic> json) {
    return RecurringExpenseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] as String,
      repeatType: json['repeat_type'] as String,
      nextDueDate: DateTime.parse(json['next_due_date'] as String),
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

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

  Map<String, dynamic> toJson() => _$RecurringExpenseModelToJson(this);

  Map<String, dynamic> toRemoteJson(String userId) => {
    'id': id,
    'user_id': userId,
    'category_id': categoryId,
    'title': title,
    'amount': amount,
    'repeat_type': repeatType,
    'next_due_date': nextDueDate.toIso8601String().substring(0, 10),
    'is_active': isActive,
  };

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
