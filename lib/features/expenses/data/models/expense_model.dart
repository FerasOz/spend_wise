import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/expense.dart';

part 'expense_model.g.dart';

@JsonSerializable()
class ExpenseModel {
  const ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note,
  });

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String? note;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      categoryId: expense.categoryId,
      date: expense.date,
      note: expense.note,
    );
  }

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  Expense toEntity() {
    return Expense(
      id: id,
      title: title,
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note,
    );
  }
}
