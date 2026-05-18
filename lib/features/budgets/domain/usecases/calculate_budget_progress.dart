import '../entities/budget_progress.dart';
import '../entities/budget.dart';

class CalculateBudgetProgress {
  const CalculateBudgetProgress();

  BudgetProgress call(Budget budget) {
    final progress = budget.limitAmount == 0
        ? 0.0
        : budget.spentAmount / budget.limitAmount;
    final status = progress >= 1
        ? BudgetProgressStatus.exceeded
        : (progress >= 0.8
              ? BudgetProgressStatus.warning
              : BudgetProgressStatus.safe);

    return BudgetProgress(
      budget: budget,
      progress: progress.clamp(0.0, progress > 1 ? progress : 1.0),
      status: status,
    );
  }
}
