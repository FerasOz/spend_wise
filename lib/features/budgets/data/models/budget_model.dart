import '../../domain/entities/budget.dart';

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

  factory BudgetModel.fromEntity(Budget budget) {
    return BudgetModel(
      id: budget.id,
      categoryId: budget.categoryId,
      limitAmount: budget.limitAmount,
      period: budget.period.name,
      createdAt: budget.createdAt,
    );
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'] as String,
      categoryId: map['categoryId'] as String,
      limitAmount: (map['limitAmount'] as num).toDouble(),
      period: map['period'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'limitAmount': limitAmount,
      'period': period,
      'createdAt': createdAt.toIso8601String(),
    };
  }

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
