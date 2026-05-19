// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_expense_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecurringExpenseModel _$RecurringExpenseModelFromJson(
  Map<String, dynamic> json,
) => RecurringExpenseModel(
  id: json['id'] as String,
  title: json['title'] as String,
  amount: (json['amount'] as num).toDouble(),
  categoryId: json['categoryId'] as String,
  repeatType: json['repeatType'] as String,
  nextDueDate: DateTime.parse(json['nextDueDate'] as String),
  isActive: json['isActive'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RecurringExpenseModelToJson(
  RecurringExpenseModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'amount': instance.amount,
  'categoryId': instance.categoryId,
  'repeatType': instance.repeatType,
  'nextDueDate': instance.nextDueDate.toIso8601String(),
  'isActive': instance.isActive,
  'createdAt': instance.createdAt.toIso8601String(),
};
