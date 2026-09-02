import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/budget.dart';

part 'budget_model.g.dart';

@JsonSerializable()
class BudgetModel {
  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    required this.period,
    required this.createdAt,
  });

  final String id;
  final String categoryId;
  final double limitAmount;
  final String period;
  final DateTime createdAt;

  factory BudgetModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetModelFromJson(json);

  factory BudgetModel.fromRemoteJson(Map<String, dynamic> json) {
    return BudgetModel(
      id: json['id'] as String,
      categoryId: json['category_id'] as String,
      limitAmount: (json['limit_amount'] as num).toDouble(),
      period: json['period'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  factory BudgetModel.fromEntity(Budget budget) {
    return BudgetModel(
      id: budget.id,
      categoryId: budget.categoryId,
      limitAmount: budget.limitAmount,
      period: budget.period.name,
      createdAt: budget.createdAt,
    );
  }

  Map<String, dynamic> toJson() => _$BudgetModelToJson(this);

  Map<String, dynamic> toRemoteJson(String userId) => {
    'id': id,
    'user_id': userId,
    'category_id': categoryId,
    'limit_amount': limitAmount,
    'period': period,
  };

  Budget toEntity() {
    return Budget(
      id: id,
      categoryId: categoryId,
      limitAmount: limitAmount,
      period: BudgetPeriod.values.firstWhere(
        (value) => value.name == period,
        orElse: () => BudgetPeriod.monthly,
      ),
      createdAt: createdAt,
    );
  }
}
