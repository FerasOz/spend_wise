import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/insight_card.dart';
import '../../domain/usecases/generate_insights.dart';
import '../../../expenses/domain/entities/expense.dart';
import '../../../categories/domain/entities/category.dart';

part 'insight_state.dart';

class InsightCubit extends Cubit<InsightState> {
  InsightCubit(this._generateInsights) : super(const InsightState.initial());

  final GenerateInsights _generateInsights;

  void generateInsights(
    List<Expense> expenses,
    Map<String, Category> categoriesMap,
  ) {
    try {
      final insights = _generateInsights(expenses, categoriesMap);
      emit(InsightState.loaded(insights));
    } catch (e) {
      emit(InsightState.error(e.toString()));
    }
  }
}
