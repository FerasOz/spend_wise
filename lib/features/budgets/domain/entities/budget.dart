enum BudgetPeriod { monthly, yearly }

class Budget {
  const Budget({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    this.spentAmount = 0,
    this.period = BudgetPeriod.monthly,
    required this.createdAt,
  });

  final String id;
  final String categoryId;
  final double limitAmount;
  final double spentAmount;
  final BudgetPeriod period;
  final DateTime createdAt;

  double get remainingAmount => limitAmount - spentAmount;

  Budget copyWith({
    String? id,
    String? categoryId,
    double? limitAmount,
    double? spentAmount,
    BudgetPeriod? period,
    DateTime? createdAt,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      period: period ?? this.period,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
