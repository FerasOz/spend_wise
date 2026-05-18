import 'budget.dart';

enum BudgetProgressStatus { safe, warning, exceeded }

class BudgetProgress {
  const BudgetProgress({
    required this.budget,
    required this.progress,
    required this.status,
  });

  final Budget budget;
  final double progress;
  final BudgetProgressStatus status;
}
