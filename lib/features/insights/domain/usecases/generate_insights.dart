import '../entities/insight_card.dart';
import '../repositories/insight_repository.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

class GenerateInsights {
  const GenerateInsights(this._insightRepository);

  final InsightRepository _insightRepository;

  List<InsightCard> call(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    return _insightRepository.generateInsights(expenses, categoriesMap);
  }
}
