// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BudgetModel _$BudgetModelFromJson(Map<String, dynamic> json) => BudgetModel(
  id: json['id'] as String,
  categoryId: json['categoryId'] as String,
  limitAmount: (json['limitAmount'] as num).toDouble(),
  period: json['period'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$BudgetModelToJson(BudgetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'limitAmount': instance.limitAmount,
      'period': instance.period,
      'createdAt': instance.createdAt.toIso8601String(),
    };
