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
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  factory ExpenseModel.fromRemoteJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] as String,
      date: DateTime.parse(json['expense_date'] as String),
      note: json['note'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      id: expense.id,
      title: expense.title,
      amount: expense.amount,
      categoryId: expense.categoryId,
      date: expense.date,
      note: expense.note,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => _$ExpenseModelToJson(this);

  Map<String, dynamic> toRemoteJson(String userId) => {
    'id': id,
    'user_id': userId,
    'category_id': categoryId,
    'title': title,
    'amount': amount,
    'expense_date': date.toIso8601String().substring(0, 10),
    'note': note,
  };

  Expense toEntity() {
    return Expense(
      id: id,
      title: title,
      amount: amount,
      categoryId: categoryId,
      date: date,
      note: note,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
